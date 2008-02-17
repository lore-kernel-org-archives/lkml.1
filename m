Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYBQRTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYBQRTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYBQRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:18:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYBQRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:18:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=c/VXN9kef/p8BmRFHPsa683tRy1kDPHfbxOmH4Y8uIQyAGvgFWP6BRr3jJgCTvObF
	MaIrI//zEM7ejE785NF/Q==
Message-ID: <6599ad830802170918q4c748f7fs32e5b8ea63e49f15@mail.gmail.com>
Date: Sun, 17 Feb 2008 09:18:44 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup structured file API
Cc: balbir@in.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080216212901.70fe35ce.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204821.778088000@menage.corp.google.com>
	 <20080216212901.70fe35ce.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 7:29 PM, Paul Jackson <pj@sgi.com> wrote:
>
> From: Paul Jackson <pj@sgi.com>
>
> Strip all trailing whitespace (such as carriage returns)
> when parsing integer writes to cgroup files, not just
> one trailing newline if present.

Sounds like a good idea to me. Thanks for this.

>
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Cc: Paul Menage <menage@google.com>

Acked-by: Paul Menage <menage@google.com>

>
> ---
>  kernel/cgroup.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> --- 2.6.24-mm1.orig/kernel/cgroup.c     2008-02-16 04:20:33.000000000 -0800
> +++ 2.6.24-mm1/kernel/cgroup.c  2008-02-16 19:00:41.207478218 -0800
> @@ -1321,10 +1321,7 @@ static ssize_t cgroup_write_uint(struct
>                 return -EFAULT;
>
>         buffer[nbytes] = 0;     /* nul-terminate */
> -
> -       /* strip newline if necessary */
> -       if (nbytes && (buffer[nbytes-1] == '\n'))
> -               buffer[nbytes-1] = 0;
> +       strstrip(buffer);       /* strip -just- trailing whitespace */
>         val = simple_strtoull(buffer, &end, 0);
>         if (*end)
>                 return -EINVAL;
>
>
> --
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
>
