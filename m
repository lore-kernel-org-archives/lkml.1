Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZFSXPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZFSXPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZFSXPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:15:31 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36026 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFSXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:15:31 -0400
Date: Fri, 19 Jun 2009 16:15:34 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
In-Reply-To: <20090619224403.GA27322@kroah.com>
Message-ID: <Pine.LNX.4.64.0906191556480.7980@cobra.newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <20090619224403.GA27322@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Greg KH wrote:
> On Fri, Jun 19, 2009 at 03:31:21PM -0700, Sage Weil wrote:
> > This is a patch series for v0.9 of the Ceph distributed file system
> > client (against v2.6.30).
> > 
> > Greg, the first patch in the series creates an fs/staging/ directory.
> > This is analogous to drivers/staging/ (not built by allyesconfig,
> > modpost will mark the module with 'staging', etc.), except you can
> > find it under the File Systems section (and it doesn't get hidden
> > along with drivers/ on UML).
> > 
> > If that looks reasonable, I would love to see this go into the staging
> > tree.  The remaining patches add Ceph at fs/staging/ceph.
> 
> No, please put "staging" filesystems at drivers/staging/ where the other
> filesystems that are in "staging" shape are.
> 
> This is due to some core changes needed to mark such modules as
> "TAINT_CRAP", and to make it obvious who is to blame for such crap :)

Ah, okay.  I thought this modpost.c change would be enough to accomplish 
that, but I didn't look too closely:

@@ -1721,8 +1721,10 @@ static void add_header(struct buffer *b, struct 
module *mod)
 void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
+	static const char *fsstaging_dir = "fs/staging";
 
-	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0)
+	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0 ||
+	    strncmp(fsstaging_dir, name, strlen(fsstaging_dir)) == 0)
 		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
 }

Are the core changes onerous?  If you don't object in principle, it would 
be nice if staging file systems were easier to find.

sage
