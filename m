Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYIQLtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYIQLtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 07:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYIQLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 07:49:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:39195 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYIQLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 07:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S2MKcNInqH1J85+fzgOlwPhyzISArVMXKrVY1kRq5xuzTtqhhHefnk6Q1yakUKZ5rR
         GNxnZcrrWE8hKB6CW9JtDNyb4fh/dyZzjdkDCsaITjI9EBAOlUupH5eYVVFRv7fli32A
         2HvZthF9PWfwlEeUBFkTIu4HZcAVVk6ImJzpQ=
Date: Wed, 17 Sep 2008 12:49:38 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uml: Make vde_user.c build again
Message-ID: <20080917114938.GB2898@hack.voiplan.pt>
References: <1221612200-483-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221612200-483-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 09:43:19PM -0300, Alberto Bertogli wrote:
>Commit 43f5b308 ("uml: fix build when SLOB is enabled") removed kmalloc()
>from um_malloc.h, which breaks vde_user.c.
>
>This patch fixes it by making vde_user.c call uml_kmalloc() instead of
>kmalloc().
>
>Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
>---
>
>This patch is against the Linus' current (as of about 5 minutes ago) tree.
>Without this patch, it wouldn't build.
>
>I've tested it by booting my uml image, connecting it to the internet using
>vde_witch, and doing some network operations (some aptitude installs).
>
>Thanks a lot,
>		Alberto
>
>
> arch/um/drivers/vde_user.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
>index 56533db..744eacf 100644
>--- a/arch/um/drivers/vde_user.c
>+++ b/arch/um/drivers/vde_user.c
>@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
> {
> 	struct vde_open_args *args;
> 
>-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
>+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
> 	if (vpri->args == NULL) {
> 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
> 		       "allocation failed");

http://lkml.org/lkml/2008/7/23/142


-- 
"Sometimes the only way to stay sane is to go a little crazy."

