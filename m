Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYFUAKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYFUAKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbYFUAKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:10:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbYFUAKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:10:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=Z3vNYrnp8BGrDyF6Ezso3Fg7oyR3a5+GpyqHXRRCbLJuPoDCHmnm40wydGfrVN+ks
	y5tlxyyFkMddkWTg7qg5w==
Message-Id: <20080620234358.182933000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jun 2008 16:43:58 -0700
From: menage@google.com
To: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 0/8] CGroup Files: Add write_string control file method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of a patchset that I sent last month, reworked to
remove some controversial locking proposals. All locking is now explicit.

This patchset provides:

1) A new write_string() cgroup file method that copies the user's data
to kernel space and invokes the relevant handler with the
nul-terminated kernelspace buffer

2) A new helper function, cgroup_lock_live_group(), which combines
taking the cgroup lock and checking the liveness of a cgroup, to allow
simplification of a common lock/check idiom in cgroup file handlers.

3) Conversion of several raw write handlers in cgroup, cpuset,
devcgroup and res_counter to use typed handlers and the new locking
specifications.

Signed-off-by: Paul Menage <menage@google.com>

--
