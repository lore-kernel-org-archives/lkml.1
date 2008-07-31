Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYGaEgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYGaEgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYGaEgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:36:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbYGaEgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:36:16 -0400
Date: Wed, 30 Jul 2008 21:35:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Teigland <teigland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm updates for 2.6.27
Message-Id: <20080730213556.df1fed99.akpm@linux-foundation.org>
In-Reply-To: <20080728161158.GA981@redhat.com>
References: <20080728161158.GA981@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 11:11:58 -0500 David Teigland <teigland@redhat.com> wrote:

> please pull dlm updates for 2.6.27 from:

sparc allmodconfig explodes in -mm:

fs/dlm/config.c:282: error: redefinition of 'struct node'
fs/dlm/config.c:390: error: expected identifier or '(' before '{' token
fs/dlm/config.c: In function 'drop_node':
fs/dlm/config.c:582: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c:582: warning: type defaults to 'int' in declaration of '__mptr'
fs/dlm/config.c:582: warning: initialization from incompatible pointer type
fs/dlm/config.c:582: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c: In function 'release_node':
fs/dlm/config.c:594: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c:594: warning: type defaults to 'int' in declaration of '__mptr'
fs/dlm/config.c:594: warning: initialization from incompatible pointer type
fs/dlm/config.c:594: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c: In function 'show_node':
fs/dlm/config.c:708: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c:708: warning: type defaults to 'int' in declaration of '__mptr'
fs/dlm/config.c:708: warning: initialization from incompatible pointer type
fs/dlm/config.c:708: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c: In function 'store_node':
fs/dlm/config.c:717: error: 'struct node' has no member named 'sysdev'
fs/dlm/config.c:717: warning: type defaults to 'int' in declaration of '__mptr'
fs/dlm/config.c:717: warning: initialization from incompatible pointer type
fs/dlm/config.c:717: error: 'struct node' has no member named 'sysdev'


Because there's already a `struct node' in include/linux/node.h.

This is because some random unrelated patch
(vmscan-unevictable-lru-scan-sysctl.patch) in -mm has caused
include/linux/node.h to get included in the fs/dlm/config.c build on
sparc32.

`struct node' was a poor choice of name!  Please rename it prior to the
2.6.27 release so that bisectability won't break if/when we merge
vmscan-unevictable-lru-scan-sysctl.patch.  Plus this bug might already
be present in mainline, only nobody has yet found the config which
triggers it.

