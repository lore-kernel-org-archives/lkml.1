Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbYDODNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbYDODNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbYDODNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:13:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:52653 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761580AbYDODNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WwZLjiCZhEsrQ17okfW7A5+STTvW836WMPMhW09HaJiB06KlMnJs5NMrPJpVf2RXQAtKh7sMSa34pZGvsQTVaSJFfeFfCpdnd9szfWX7OmDB/qFzrjUbvdIcgSfaMqqFtCEqAVBYyaam9igevcDK5a4b1Gzc6Pf9wys6SEFZYjg=
Message-ID: <ed10ee420804142013ld540b76g200b459f13b34d@mail.gmail.com>
Date: Mon, 14 Apr 2008 20:13:40 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] sysfs: add /sys/dev/{char, block} to lookup sysfs path by major:minor
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       neilb@suse.de, htejun@gmail.com, hpa@zytor.com, lkml@rtr.ca
In-Reply-To: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
X-Google-Sender-Auth: 1c58f1b41163d723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/08, Dan Williams <dan.j.williams@intel.com> wrote:

>  This is the second revision of the patch originally posted here:
>  http://marc.info/?l=linux-kernel&m=120795638915272&w=2
>
>  * Fixed up ENOMEM handling in devices_init()
>  * Added a short blurb in Documentation/filesystems/sysfs.txt
>
>   Documentation/filesystems/sysfs.txt |    6 +++++
>   drivers/base/core.c                 |   46 ++++++++++++++++++++++++++++++++++-
>   2 files changed, 51 insertions(+), 1 deletions(-)

I've looked this patch over and I have some comments.  The logic looks
correct, but there are two ugly lines.

>  @@ -775,6 +783,7 @@ int device_add(struct device *dev)
>         struct device *parent = NULL;
>         struct class_interface *class_intf;
>         int error;
>  +       char devt_str[25];

>  @@ -925,12 +944,16 @@ void device_del(struct device *dev)
>   {
>         struct device *parent = dev->parent;
>         struct class_interface *class_intf;
>  +       char devt_str[25];

May I ask why `25'?  The only other user of format_dev_t that I could find
in a quick grep is md (device-mapper) and they used a hardcoded `15' there.
The real problem is format_dev_t and print_dev_t.

If the only other user of those macros which want to be C inlines with
buffer size parameters is md, perhaps now would be a good time to clean
them up before adding more users?

Otherwise, the logic looks O.K.

Add my
Reviewed-by: SL Baur <steve@xemacs.org>
if that is appropriate.

-sb
