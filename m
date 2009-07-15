Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZGOJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZGOJkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZGOJkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:40:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45511 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbZGOJkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SXbAPC5bnLB4Tf2fSFY5nhQ+M9oc1lRVbRZP/Ywo+P/ODXQp59QfplBPF8yuRsazuZ
         xSEjlyjtgBEUTYQQyaQfk0GqlMNlQoQ6lN5ATIJzIC0zehRvSKG1hH3WfLkTllK2wZ5p
         fr5ybz6WmKhqFkFmghzjOWR1zJljPBa9nNkUA=
MIME-Version: 1.0
In-Reply-To: <1247587564-27737-3-git-send-email-mjg@redhat.com>
References: <1247587564-27737-1-git-send-email-mjg@redhat.com>
	 <1247587564-27737-2-git-send-email-mjg@redhat.com>
	 <1247587564-27737-3-git-send-email-mjg@redhat.com>
Date: Wed, 15 Jul 2009 11:40:08 +0200
Message-ID: <71cd59b00907150240q22e8694el281cf862e71e1b66@mail.gmail.com>
Subject: Re: [PATCH 3/3] eeepc-laptop: Update the backlight state when we 
	change brightness
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 6:06 PM, Matthew Garrett<mjg@redhat.com> wrote:
> Trigger a status update when the user hits a brightness key, allowing
> userspace to present appropriate UI.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index ec560f1..fde86b3 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -641,7 +641,7 @@ static int notify_brn(void)
>        struct backlight_device *bd = eeepc_backlight_device;
>        if (bd) {
>                int old = bd->props.brightness;
> -               bd->props.brightness = read_brightness(bd);
> +               backlight_force_update(bd, BACKLIGHT_UPDATE_HOTKEY);
>                return old;
>        }
>        return -1;
> --
> 1.6.2.5
>
>

This could be added to asus-laptop too. It doesn't handle brightness
changes right now (only backlight on/off) but it works the same way,
so it won't be hard to add. I'll do that as soon as your main patch is
merged.
Thanks,


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
