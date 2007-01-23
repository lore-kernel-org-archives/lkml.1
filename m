Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXAWHgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXAWHgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 02:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbXAWHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 02:36:36 -0500
Received: from main.gmane.org ([80.91.229.2]:35758 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbXAWHgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 02:36:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: [fix, rfc] kbuild: O= with M= (Re: [PATCH -mm] replacement for broken kbuild-dont-put-temp-files-in-the-source-tree.patch)
Date: Tue, 23 Jan 2007 07:36:13 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerbf7h.e7s.olecom@flower.upol.cz>
References: <20061029120858.GB3491@quickstop.soohrt.org> <slrnekcu6m.2vm.olecom@flower.upol.cz> <20061031001235.GE2933@quickstop.soohrt.org> <200610310119.10567.ak@suse.de> <20061031011416.GG2933@quickstop.soohrt.org> <20061031135136.GB16063@flower.upol.cz> <20061117051729.GA12896@flower.upol.cz>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2006-11-17, Oleg Verych wrote:
> On Tue, Oct 31, 2006 at 02:51:36PM +0100, olecom wrote:
> []
>> On Tue, Oct 31, 2006 at 02:14:16AM +0100, Horst Schirmeier wrote:
> []
>> > I'm not sure what you mean by $(objdir); I just got something to work
>> > which creates the /dev/null symlink in a (newly created if necessary)
>> > directory named
>> 
>> $(objtree) is a directory for all possible outputs of the build precess,
>> it's set up by `O=' or `KBUILD_OUTPUT', and this is *not* output for ready
>> external modules `$(M)'. Try to play with this, please.
>
> And for me, they are *not* working together:

It works with this:

Proposed-by: me

--- linux-2.6.20-rc5/scripts/Makefile.modpost.orig	2007-01-12 19:54:26.000000000 +0100
+++ linux-2.6.20-rc5/scripts/Makefile.modpost	2007-01-23 08:23:51.583426500 +0100
@@ -58,5 +58,5 @@
 #  Includes step 3,4
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = scripts/mod/modpost            \
+      cmd_modpost = $(objtree)/scripts/mod/modpost \
         $(if $(CONFIG_MODVERSIONS),-m)             \
 	$(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)  \
>> ____
> ____
____

