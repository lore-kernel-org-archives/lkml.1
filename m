Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYFYXcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYFYXcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYFYXby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:31:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbYFYXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:31:53 -0400
Date: Wed, 25 Jun 2008 16:30:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] capabilities: refactor kernel code + bugfix
Message-Id: <20080625163035.b409d693.akpm@linux-foundation.org>
In-Reply-To: <485BCEEB.30105@kernel.org>
References: <485BCEEB.30105@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 08:38:19 -0700
"Andrew G. Morgan" <morgan@kernel.org> wrote:

> From 8a2bffcb5363295ea43ef42c84c121a8e8c7ffa0 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Fri, 20 Jun 2008 08:16:06 -0700
> Subject: [PATCH] Refactor filesystem capability support in main kernel.
> 
> To date, we've tried hard to confine filesystem support for capabilities
> to the security modules. This has left a lot of the code in
> kernel/capability.c in a state where it looks like it supports something
> that filesystem support for capabilities actually suppresses when the
> LSM security/commmoncap.c code runs. What is left is a lot of code that
> uses sub-optimal locking in the main kernel. With this change we refactor
> the main kernel code and make it explicit which locks are needed and that
> the only remaining kernel races in this area are associated with
> non-filesystem capability code.
> 
> This commit also includes a bugfix for the fragile setuid fixup
> code in the case that filesystem capabilities are supported (in access()).
> The effect of this fix is gated on filesystem capability support because
> changing securebits is only supported when filesystem capabilities support
> is configured.)
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> ---
>  fs/open.c                  |   38 +++--
>  include/linux/capability.h |    2 +
>  include/linux/securebits.h |   15 +-
>  kernel/capability.c        |  359 +++++++++++++++++++++++++++++--------------

This is one helluva large (security!) patch for so late in -rc.

Could we please split out the bugfix for 2.6.26 (is it needed in 2.6.25
too?) and hold the refactoring back for 2.6.27?

