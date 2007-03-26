Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXCZAFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXCZAFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXCZAFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:05:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:13097 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbXCZAFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Na4mi50LEwMiMGHf7U9Bye1XyvYFEfDGJVPtGW7WDoGeC9FDLGEraqZ5GJdFOhuxX1q0z6QMh0B4IDgY0T+oolHWicgc/4UHirjoR+Jn+sw396pKQCYgK5tppxHrxgOCJHtO389RtW2jbr6u1qg9wZ6NrpvGq/JmZCjTmPGtt8E=
Message-ID: <2a12af650703251705x30a05194je1cfece44b2cf45d@mail.gmail.com>
Date: Mon, 26 Mar 2007 03:05:19 +0300
From: "Marti Raudsepp" <marti@juffo.org>
To: "Milan Broz" <mbroz@redhat.com>
Subject: Re: [PATCH] disable barriers in dm-crypt [was Re: BUG: Files corrupt after moving LVM volume to USB disk]
Cc: "Alasdair G Kergon" <agk@redhat.com>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "device-mapper development" <dm-devel@redhat.com>,
       "Kernel hackers" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christophe Saout" <christophe@saout.de>
In-Reply-To: <4603E806.3030205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070322000348.92631512.akpm@linux-foundation.org>
	 <20070322153301.GN27600@agk.surrey.redhat.com>
	 <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
	 <4603E806.3030205@redhat.com>
X-Google-Sender-Auth: ba5feb4ae9931abd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Milan Broz <mbroz@redhat.com> wrote:
> Disable barriers in dm-crypt because of current workqueue processing
> can reorder requests.
>
> --- linux-2.6.20.1.orig/drivers/md/dm-crypt.c   2007-03-23 15:07:11.000000000 +0100
> +++ linux-2.6.20.1/drivers/md/dm-crypt.c        2007-03-23 15:09:59.000000000 +0100
> +       if (bio_barrier(bio))
> +               return -EOPNOTSUPP;
> +

Sorry, this doesn't help either. ext3 is still slow, reiserfs still fails.

(And sorry for the double e-mail, I forgot to reply to all)

Marti Raudsepp
