Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbYFLMIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbYFLMIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbYFLMHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:44 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4314 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969AbYFLMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:43 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: update checkpatch to version 0.20
Date: Thu, 12 Jun 2008 13:05:39 +0100
Message-Id: <1213272362-19457-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following this email is the next batch of updates to checkpatch.
This marks a change in how I intend to send updates.  The previous
"single delta" update caused us to lose a patch from Greg KH (which is
re-included in this update), bad.  By sending the actual patches we avoid
regressing anything I have missed, it also has the advantage of maintaining
individual changes to carry signoff more accurately and generally being
more transparent.

This version brings a few new checks and the usual slew of fixes for
false positives mostly in type detection.  Of note:

  - allow printk text strings to bust the width restrictions for
    grepability,
  - major fixes for possible type/modifier handling,
  - trailing statement checks for case and default,
  - trailing statement checks for for and while,
  - spacing checks for square brackets '[' ']',
  - conditions/loops indent checks, and
  - checks for new use of __initcall.

Complete changelog below.

-apw

Andy Whitcroft (20):
      checkpatch: Version: 0.20
      checkpatch: return is not a function -- parentheses for casts are ok too
      checkpatch: types: some types may also be identifiers
      checkpatch: possible types: __asm__ is never a type
      checkpatch: comment detection: ignore macro continuation when
	      detecting associated comments
      checkpatch: types: unary -- goto introduces unary context
      checkpatch: macros: fix statement counting block end detection
      checkpatch: trailing statement indent: fix end of statement location
      checkpatch: allow printk strings to exceed 80 characters to
	      maintain their searchability
      checkpatch: switch -- report trailing statements on case and default
      checkpatch: check spacing for square brackets
      checkpatch: toughen trailing if statement checks and extend them
	      to while and for
      checkpatch: condition/loop indent checks
      checkpatch: allow for type modifiers on multiple declarations
      checkpatch: improve type matcher debug
      checkpatch: possible modifiers are not being correctly matched
      checkpatch: macro complexity checks are meaningless in linker scripts
      checkpatch: handle return types of pointers to functions
      checkpatch: possible types -- known modifiers cannot be types
      checkpatch: possible modifiers -- handle multiple modifiers and trailing

Greg Kroah-Hartman (1):
      checkpatch: usb_free_urb() can take NULL

Michael Ellerman (1):
      checkpatch: add a checkpatch warning for new uses of __initcall().

Wolfram Sang (1):
      checkpatch: correct spelling in kfree checks
