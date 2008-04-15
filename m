Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbYDOEqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbYDOEqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 00:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYDOEqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 00:46:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:58373 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYDOEqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 00:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EREC632JHm9T60XbxjKkmImLBT1LWELXwbvNNAG8brZZzgYdu94PD7EJJwEHg3ulrD45Cs940idefDQJ8rQ8FbIGdqBY4F4nFkN1M5bp4SuJHnfqwExVJmUU+lpBOAsGsJkz9PbQO34/mwk9vxy+PZfhCDTveyv0VKtuiOeDPFE=
Message-ID: <e9c3a7c20804142146h73095148o15cc75d57079ff55@mail.gmail.com>
Date: Mon, 14 Apr 2008 21:46:21 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "SL Baur" <steve@xemacs.org>
Subject: Re: [PATCH] sysfs: add /sys/dev/{char, block} to lookup sysfs path by major:minor
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       neilb@suse.de, htejun@gmail.com, hpa@zytor.com, lkml@rtr.ca
In-Reply-To: <ed10ee420804142013ld540b76g200b459f13b34d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
	 <ed10ee420804142013ld540b76g200b459f13b34d@mail.gmail.com>
X-Google-Sender-Auth: f316129277c9801c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 8:13 PM, SL Baur <steve@xemacs.org> wrote:
> On 4/14/08, Dan Williams <dan.j.williams@intel.com> wrote:
>
>  >  This is the second revision of the patch originally posted here:
>  >  http://marc.info/?l=linux-kernel&m=120795638915272&w=2
>  >
>  >  * Fixed up ENOMEM handling in devices_init()
>  >  * Added a short blurb in Documentation/filesystems/sysfs.txt
>  >
>  >   Documentation/filesystems/sysfs.txt |    6 +++++
>  >   drivers/base/core.c                 |   46 ++++++++++++++++++++++++++++++++++-
>  >   2 files changed, 51 insertions(+), 1 deletions(-)
>
>  I've looked this patch over and I have some comments.  The logic looks
>  correct, but there are two ugly lines.
>
>
>  >  @@ -775,6 +783,7 @@ int device_add(struct device *dev)
>  >         struct device *parent = NULL;
>  >         struct class_interface *class_intf;
>  >         int error;
>  >  +       char devt_str[25];
>
>
> >  @@ -925,12 +944,16 @@ void device_del(struct device *dev)
>  >   {
>  >         struct device *parent = dev->parent;
>  >         struct class_interface *class_intf;
>  >  +       char devt_str[25];
>
>  May I ask why `25'?  The only other user of format_dev_t that I could find
>  in a quick grep is md (device-mapper) and they used a hardcoded `15' there.
>  The real problem is format_dev_t and print_dev_t.
>
>  If the only other user of those macros which want to be C inlines with
>  buffer size parameters is md, perhaps now would be a good time to clean
>  them up before adding more users?
>
>  Otherwise, the logic looks O.K.
>

Thanks for looking it over.  To be honest I was iffy about those
buffer sizes as well, and looking closer they are overkill.  Although,
they are smaller than the 32-byte buffer in bsg.c :-). 13-bytes is all
that is needed given a 12-bit major and 20-bit minor.  Care to send a
patch to fix up format_dev_t and print_dev_t?

>  Add my
>  Reviewed-by: SL Baur <steve@xemacs.org>
>  if that is appropriate.
>

Yes, appropriate.

Thanks,
Dan
