Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZJ0G7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZJ0G7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbZJ0G7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:59:04 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41978 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbZJ0G7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=u9oxdFdtxgCwi3dTO7aRL1Lsxp2WI/C2H0Hwp4pEbN9B5ib9e95u69k6vSt+0SxMU6
         sMnz1PUyd4NkqezvWzWmXVSukHo5/hTFtE9yWca/nwdwNaZIJyenGHHIdYy7/jm/WD3h
         CrcgxQf0XNdup7ZoQU8ageODtfmnL7GC9EC6E=
Date: Tue, 27 Oct 2009 14:58:58 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] tracing: recordmcount.pl Support absolute path
	check on $inputfile
Message-ID: <20091027065858.GC22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fdf89709ddf4a6ff2f2d21ff8a964e949a069fe4 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:32:18 +0800
Subject: [PATCH] tracing: recordmcount.pl Support absolute path check on $inputfile

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0850b83..94daf9e 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -122,9 +122,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
-    exit(0);
-}
+exit (0) if ($inputfile =~ "kernel/trace/ftrace.o");
 
 # Acceptable sections to record.
 my %text_sections = (
-- 
1.6.0.4

