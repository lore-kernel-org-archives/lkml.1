Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298Ab0AEWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0AEWFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219Ab0AEWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:05:52 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40342 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab0AEWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:05:48 -0500
Message-Id: <20100105220417.400092933@quilx.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Jan 2010 16:04:17 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V1 0/4] Remove local_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current -next has only the trace subsystem left as a user of local_t

Tracing uses local_t for per cpu safe atomic operations in the form
of cmpxchg and additions. We already have a cmpxchg_local but no "local"
form of addition.

The patchset introduces a similar local primitive add_local() and then
uses cmpxchg_local() and add_local() to remove local_t use from the
trace subsystem.

The last patch removes local_t support from the kernel tree.

The support for add_local() is pretty basic. We can add more
fancy inc/dec variants and more optimization in the next
revision of the patchset.

