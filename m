Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZLYLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZLYLbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 06:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZLYLbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 06:31:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:45212 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZLYLbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 06:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IuI0zPwpSqdX1Wvz4iTLPkhmq3nu4DaC6mn+8HuBzUtdmSzT19Bs5b1Ti8da3OCn+E
         my/elvHov3VY/9RMKqHrypcAXrXOdeYYLrTOMiT54TBaAScdQc76YYFM/SIc/0t8UlQj
         Gu1FMNeYlnWgyzdln9YfIG3/xFVYzHiT3lDwE=
MIME-Version: 1.0
In-Reply-To: <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
	 <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com>
Date: Fri, 25 Dec 2009 13:31:20 +0200
X-Google-Sender-Auth: df7aa2c6c30332f0
Message-ID: <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com>
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 
	2.6.32-git-053fe57ac v2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 2:00 AM,  <re.emese@gmail.com> wrote:
> From: Emese Revfy <re.emese@gmail.com>
>
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  mm/slub.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 4996fc7..fb63aca 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
>        return 0;
>  }
>
> -static struct kset_uevent_ops slab_uevent_ops = {
> +static const struct kset_uevent_ops slab_uevent_ops = {
>        .filter = uevent_filter,
>  };

  CC      mm/slub.o
mm/slub.c: In function 'slab_sysfs_init':
mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
discards qualifiers from pointer target type
include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
but argument is of type 'const struct kset_uevent_ops *'

Hmm?
