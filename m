Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYADQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYADQNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYADQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:13:38 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39222 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYADQNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:13:37 -0500
Date: Fri, 4 Jan 2008 17:13:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: Re: [PATCH 1/3] Merge mkubootimg tool for building U-Boot images
Message-ID: <20080104161336.GB31026@uranus.ravnborg.org>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com> <20080103160244.6a28519b@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080103160244.6a28519b@zod.rchland.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 04:02:44PM -0600, Josh Boyer wrote:
> Several platforms require the mkimage tool to generate a uImage file that is
> used with U-Boot.  This brings the mkimage tool in-kernel to enable building
> those platforms without having mkimage externally provided.  The tool is named
> mkubootimg for better clarity.
> 
> This is currently based off of the version found in U-Boot 1.3.1.

I got following warnings:
 HOSTCC  scripts/mkubootimg/mkimage.o
scripts/mkubootimg/mkimage.c:40: warning: function declaration isn’t a prototype
scripts/mkubootimg/mkimage.c: In function ‘main’:
scripts/mkubootimg/mkimage.c:199: warning: dereferencing type-punned pointer will break strict-aliasing rules
scripts/mkubootimg/mkimage.c:216: warning: dereferencing type-punned pointer will break strict-aliasing rules

And sparse gave following warnings (with default options)
$ sparse -DUSE_HOSTCC *.c
crc32.c:154:5: warning: non-ANSI definition of function 'crc32'
/usr/include/asm/errno.h:9:4: warning: This machine appears to be neither x86_64 nor i386.
/usr/include/asm/socket.h:9:4: warning: This machine appears to be neither x86_64 nor i386.
mkimage.c:40:12: warning: non-ANSI function declaration of function '__errno_location'
mkimage.c:574:8: warning: non-ANSI function declaration of function 'usage'
mkimage.c:46:6: warning: symbol 'cmdname' was not declared. Should it be static?
mkimage.c:56:15: warning: symbol 'arch_name' was not declared. Should it be static?
mkimage.c:78:15: warning: symbol 'os_name' was not declared. Should it be static?
mkimage.c:102:15: warning: symbol 'type_name' was not declared. Should it be static?
mkimage.c:115:15: warning: symbol 'comp_name' was not declared. Should it be static?
mkimage.c:138:6: warning: symbol 'datafile' was not declared. Should it be static?
mkimage.c:139:6: warning: symbol 'imagefile' was not declared. Should it be static?
mkimage.c:141:5: warning: symbol 'dflag' was not declared. Should it be static?
mkimage.c:142:5: warning: symbol 'eflag' was not declared. Should it be static?
mkimage.c:143:5: warning: symbol 'lflag' was not declared. Should it be static?
mkimage.c:144:5: warning: symbol 'vflag' was not declared. Should it be static?
mkimage.c:145:5: warning: symbol 'xflag' was not declared. Should it be static?
mkimage.c:146:5: warning: symbol 'opt_os' was not declared. Should it be static?
mkimage.c:147:5: warning: symbol 'opt_arch' was not declared. Should it be static?
mkimage.c:148:5: warning: symbol 'opt_type' was not declared. Should it be static?
mkimage.c:149:5: warning: symbol 'opt_comp' was not declared. Should it be static?
mkimage.c:151:16: warning: symbol 'header' was not declared. Should it be static?
mkimage.c:152:16: warning: symbol 'hdr' was not declared. Should it be static?
mkimage.c:300:31: warning: Using plain integer as NULL pointer
mkimage.c:438:30: warning: Using plain integer as NULL pointer
mkimage.c:518:30: warning: Using plain integer as NULL pointer
mkimage.c:574:1: warning: symbol 'usage' was not declared. Should it be static?

Please fix and resubmit (without the sha1 files).

	Sam
