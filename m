Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbXGTEgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbXGTEgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbXGTEgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:36:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:55076 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXGTEgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DooEgEELKfLEvAC/4h2HDLTzXQWjPtU6A/7kyrVGWr3e+z1eLI3yoChpdTbJIWk6tS+SYZciCiayCH6HHxIN/PgugndlgLUBT9VJk2rLqOKAzroBPQQdlg43xk78s3lNTZTX+sqRBqwBNpguDvSOw4T/qo6xFabDjGMeffJWRsA=
Message-ID: <a781481a0707192136h601bdf0fm14a9a664a7bfa82d@mail.gmail.com>
Date: Fri, 20 Jul 2007 10:06:13 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] Memory leak in tpm_ascii_bios_measurements_open() fix.
Cc: "Reiner Sailer" <sailer@us.ibm.com>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       kjhall@linux.vnet.ibm.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Seiji Munetoh" <munetoh@jp.ibm.com>,
       "Reiner Sailer" <sailer@watson.ibm.com>, stefanb@us.ibm.com
In-Reply-To: <86802c440707192120v6b6de39ek811e4f7aed9faa45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A02CED.7000309@us.ibm.com>
	 <a781481a0707192107g5bf71891qd289126220ca6189@mail.gmail.com>
	 <86802c440707192120v6b6de39ek811e4f7aed9faa45@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> out_free:
>    kfree(log->bios_event_log);
>    kfree(log);
> out:
>    return err;
>
> could kill one extra goto.

Such constructs disallow the success path from falling through
to the same "return err;" (with err = 0 for success obviously)
