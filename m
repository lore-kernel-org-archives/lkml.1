Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZBYBXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZBYBXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZBYBW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:22:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZBYBW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:22:57 -0500
Message-ID: <49A49D2B.8050701@zytor.com>
Date: Tue, 24 Feb 2009 17:21:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: linux-kernel@vger.kernel.org, Anders Kaseorg <andersk@MIT.EDU>,
       Jeff Arnold <jbarnold@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 2/4] x86: Add an option to compile with -ffunction-sections
 -fdata-sections
References: <1235521315-3424-1-git-send-email-tabbott@mit.edu> <1235521315-3424-2-git-send-email-tabbott@mit.edu> <1235521315-3424-3-git-send-email-tabbott@mit.edu>
In-Reply-To: <1235521315-3424-3-git-send-email-tabbott@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> From: Waseem Daher <wdaher@mit.edu>
> 
> This patch makes it possible to link and boot an x86 kernel with
> -ffunction-sections and -fdata-sections enabled.
> 
> Modpost currently warns whenever it sees a section with a name
> matching [.][0-9]+$ because they are often caused by section flag
> mismatch errors.  When compiling with -ffunction-sections
> -fdata-sections, gcc places various classes of local symbols in
> sections with names such as .rodata.__func__.12345, causing these
> warnings to be printed spuriously.  The simplest fix is to disable the
> warning when CONFIG_FUNCTION_DATA_SECTIONS is enabled.
> 

This is a pretty critical set of warnings, that often represent real
bugs.  I don't think it's acceptable to lose them.  However, you already
have (prior in the sequence) changed those section names to not conflict
with the automatically generated ones, so it seems to me that this
should be fixable without too much pain.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

