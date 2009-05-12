Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZELPap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZELPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZELPaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:30:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6503 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZELPaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:30:35 -0400
Message-Id: <4A09B23B02000078000007F1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 12 May 2009 16:30:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <tj@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: remap allocator for per-CPU memory
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't the addition of this allocator introduce another case that needs special
treatment in pageattr.c? Since large pages are used for mapping the allocated
memory, but only part of the initially allocated large pages are actually
retained, there's now the potential for TLB aliases with different cache
attributes for those parts of these pages that get passed back through
free_bootmem().

Jan

