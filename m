Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYLAUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYLAUVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLAUVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:21:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37436 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYLAUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:21:40 -0500
Date: Mon, 1 Dec 2008 12:21:12 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, oleg@redhat.com,
       ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 4/5] Protect cinit from fatal signals
Message-ID: <20081201202112.GC12493@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com> <20081126034634.GD23238@us.ibm.com> <20081127010753.GB13545@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127010753.GB13545@wavehammer.waldi.eu.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank [bastian@waldi.eu.org] wrote:
| On Tue, Nov 25, 2008 at 07:46:34PM -0800, Sukadev Bhattiprolu wrote:
| > To protect container-init from fatal signals, set SIGNAL_UNKILLABLE but
| > clear it if it receives SIGKILL from parent namespace - so it is still
| > killable from ancestor namespace.
| 
| This sounds like a workaround.

yes...
| 
| > Note that container-init is still somewhat special compared to 'normal
| > processes' - unhandled fatal signals like SIGUSR1 to a container-init
| > are dropped even if they are from ancestor namespace. SIGKILL from an
| > ancestor namespace is the only reliable way to kill a container-init.
| 
| It sounds not right to make this special case for a "normal" process.
| 
| However, no idea how to do this better.

... like I mentioned in the other message, we have tried different
approaches and they were either intrusive or required more drastic
changes in semantics.

Container-inits are special in some ways and this change requires SIGKILL
to terminate them.
