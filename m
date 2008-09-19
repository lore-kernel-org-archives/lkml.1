Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYISXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYISXkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYISXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:40:38 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1958 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYISXki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:40:38 -0400
X-Greylist: delayed 2749 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2008 19:40:37 EDT
Date: Fri, 19 Sep 2008 19:50:20 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uml: Make vde_user.c build again
Message-ID: <20080919225020.GU1779@blitiri.com.ar>
References: <1221612200-483-1-git-send-email-albertito@blitiri.com.ar> <20080917114938.GB2898@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917114938.GB2898@hack.voiplan.pt>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 12:49:38PM +0100, WANG Cong wrote:
> On Tue, Sep 16, 2008 at 09:43:19PM -0300, Alberto Bertogli wrote:
> >Commit 43f5b308 ("uml: fix build when SLOB is enabled") removed kmalloc()
> >from um_malloc.h, which breaks vde_user.c.
> >
> >This patch fixes it by making vde_user.c call uml_kmalloc() instead of
> >kmalloc().
> >
> >Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> >---
> >
> >This patch is against the Linus' current (as of about 5 minutes ago) tree.
> >Without this patch, it wouldn't build.
> >
> >I've tested it by booting my uml image, connecting it to the internet using
> >vde_witch, and doing some network operations (some aptitude installs).
> >
> >Thanks a lot,
> >		Alberto
> >
> >
> > arch/um/drivers/vde_user.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
> >index 56533db..744eacf 100644
> >--- a/arch/um/drivers/vde_user.c
> >+++ b/arch/um/drivers/vde_user.c
> >@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
> > {
> > 	struct vde_open_args *args;
> > 
> >-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
> >+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
> > 	if (vpri->args == NULL) {
> > 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
> > 		       "allocation failed");
> 
> http://lkml.org/lkml/2008/7/23/142

Thanks. Is there anything I can do to help get this into mainline?

The patch(es) looks really simple, and without it the build is broken if
you use vde.

Thanks a lot,
		Alberto

