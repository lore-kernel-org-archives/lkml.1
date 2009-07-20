Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZGTSEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZGTSEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZGTSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:04:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZGTSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:04:49 -0400
Date: Mon, 20 Jul 2009 20:04:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090720180446.GB16072@basil.fritz.box>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com> <1248106385-27514-8-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248106385-27514-8-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 06:12:58PM +0200, Borislav Petkov wrote:
> Use a weakly defined symbol instead of ugly ifdefs.

I'm not sure what you're trying to archive, but if you're
trying to catch corrected MCs you're hooking into the 
wrong function. print_mce is only called for PCC=1.

Also if you're checking for specific banks you
need to check for vendor/cpu model first of course.
In your current implementation e.g. a Intel CPU
would pass some random event into your AMD specific code,
which is probably not intended and might even crash.

It would be probably cleaner if you defined a standard
notifier chain interface.

-Andi
