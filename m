Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYLBGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYLBGVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYLBGVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:21:41 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48031 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYLBGVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:21:41 -0500
Message-ID: <4934D3E1.1000507@cosmosbay.com>
Date: Tue, 02 Dec 2008 07:21:21 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: fix CPU unplug panic in ppro_stop()
Content-Type: multipart/mixed;
 boundary="------------030109000103030905050505"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 02 Dec 2008 07:21:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109000103030905050505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

If oprofile statically compiled in kernel, a cpu unplug triggers
a panic in ppro_stop(), because a NULL pointer is dereferenced.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 arch/x86/oprofile/op_model_ppro.c |    4 ++++
 1 files changed, 4 insertions(+)

--------------030109000103030905050505
Content-Type: text/plain;
 name="ppro_stop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ppro_stop.patch"

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 716d26f..e9f80c7 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -156,6 +156,8 @@ static void ppro_start(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	if (!reset_value)
+		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			CTRL_READ(low, high, msrs, i);
@@ -171,6 +173,8 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	if (!reset_value)
+		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;

--------------030109000103030905050505--
