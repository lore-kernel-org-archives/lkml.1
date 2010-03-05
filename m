Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0CETnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:43:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33465 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0CETnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:43:09 -0500
Date: Fri, 5 Mar 2010 11:43:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com
Subject: [PATCH 0/2] v4 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305194305.GA23009@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch appends the localversion string to the Linux kernel version.
For example, in a git tree with uncommitted changes, the .config file
might start as follows (but with leading hash marks):

	Automatically generated make config: don't edit
	Linux kernel version: 2.6.33-01836-g90a6501-dirty
	Mon Mar  1 17:05:59 2010

The "-01836-g90a6501-dirty" string is added by this patch.

The KBUILD_CONFIG_NO_CHECK_DIRTY environment variable controls the
git "-dirty" check.  If this variable is either empty or undefined,
then a "-dirty" check is performed (the default), otherwise, this
check is omitted.

Differences from v3 (http://lkml.org/lkml/2010/3/4/520):

o	Print errors to stderr, using gcc error format so that scripts
	that pull errors from build output will find them.

o	Make error strings placed in .config file more comprehensible.

o	Make parent warn of child error return (via wait() system call).

Differences from v2 (http://lkml.org/lkml/2010/3/2/570):

o	Replace popen() with the equivalent fork-exec series
	to prevent security vulnerabilities due to shell metacharacter
	interpretation.

o	Added the KBUILD_CONFIG_NO_CHECK_DIRTY environment variable,
	and modified scripts/setlocalversion to check it, as suggested
	by James Cloos.

Differences from v1 (http://lkml.org/lkml/2010/2/28/191):

o	Incorporates feedback from Geert Uytterhoeven, Linus Torvalds,
	Frans Pop, and James Cloos.

o	Fixed to work correctly with the "O=" Makefile argument and
	the KBUILD_OUTPUT environment variable, so that .config files
	created in directories outside of the source tree are tagged
	correctly.

o	Uses scripts/setlocalversion, which handles not only git, but
	also mercurial and svn.

o	Make the new behavior default-off, as scripts/setlocalversion
	has significant latency.  A new environment variable named
	"KBUILD_CONFIG_LOCALVERSION" must be set to enable the
	"-01836-g90a6501-dirty" style of string.

	This is intended to address James Cloos's concern that this
	feature will slow down casual kernel builds.

It has been suggested that this string be output at boot and oops time.
If there is general agreement, this will be the subject of a separate
patch.

 kconfig/confdata.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 setlocalversion    |   18 +++++++------
 2 files changed, 76 insertions(+), 11 deletions(-)
