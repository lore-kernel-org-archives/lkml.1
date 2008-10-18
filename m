Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbYJRQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbYJRQVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbYJRQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:21:09 -0400
Received: from japan.chezphil.org ([77.240.5.4]:2900 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYJRQVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:21:08 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Sat, 18 Oct 2008 17:21:05 +0100
Subject: Script to build-in used modules, based on streamline_config.pl
Message-ID: <1224346865059@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

Last month, Steven Rostedt posted a script to disable 
not-currently-used modules from your .config:

   http://article.gmane.org/gmane.linux.kernel/734536

It works by parsing the kernel Makefiles to build a map from module 
names to config settings.

I've made a slightly modified version of this that takes the .config 
for an all-modular kernel (e.g. a distribution kernel) and changes the 
settings for those modules that are currently loaded so that they will 
be built in:

   http://chezphil.org/tmp/buildin_used_mods.pl

The aim of this is to provide a semi-automatic method to produce a 
custom kernel that has everything needed for your hardware built in, so 
you don't need an initrd.

One issue that I encountered is that not every config setting builds a 
module and may not be changed.  For example, if I need module xyz to 
support my IDE disk, then the script will change CONFIG_XYZ from m to 
y.  However, it won't change CONFIG_IDE from m to y.  When I 
subsequently make menuconfig, it detects that CONFIG_XYZ=y is 
incompatible with CONFIG_IDE=m, but it fixes it in the wrong way; it 
changes CONFIG_XYZ back to m, rather than changing CONFIG_IDE to y.  Is 
there any way to change this?

Someone with better Perl skills than me could probably merge Steven's 
original script with my variation with a command-line option to 
determine the behaviour.  It would be good to something like this merged.

Cheers,  Phil.



