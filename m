Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZERLPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZERLPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZERLPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:15:25 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:37483 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZERLPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:15:24 -0400
Date: Mon, 18 May 2009 13:15:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] driver core:firmware:fix request_firmware_nowait
Message-ID: <20090518131524.6e63f3e6@gondolin>
In-Reply-To: <1242482058-5203-2-git-send-email-tom.leiming@gmail.com>
References: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
	<1242482058-5203-2-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 21:54:18 +0800,
tom.leiming@gmail.com wrote:

> @@ -646,14 +646,12 @@ request_firmware_nowait(
>  		.uevent = uevent,
>  	};
> 
> -	task = kthread_run(request_firmware_work_func, fw_work,
> -			    "firmware/%s", name);
> -
> -	if (IS_ERR(task)) {
> +	ret = async_run_inatomic(request_firmware_work_func, fw_work);
> +	if (ret) {
>  		fw_work->cont(NULL, fw_work->context);
>  		module_put(fw_work->module);
>  		kfree(fw_work);
> -		return PTR_ERR(task);
> +		return ret;

You change the return code from an usual error code to a boolean value
here...

>  	}
>  	return 0;
>  }
 
