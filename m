Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYCHRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYCHRLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYCHRK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:10:59 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:19781 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYCHRK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=vR/7ytLrRN/4wiTnASUddwWLfofytxR9dxu0Dz4+sMwMhPAqeOT1nnx6h///lDdNZBSZIrjhvC9Tzv/bUE7ryjUUXEaOKm91UsZ6+boxSBAVenljqu7f/h/eQN8ShbBcccoe9AtU5Gsk1cTWjQQyULd5T/E4FOujOqvrXPZ2ysw=
Message-ID: <bc64b4640803080910w3c2905d6gd17357aafa7b2db9@mail.gmail.com>
Date: Sat, 8 Mar 2008 20:10:56 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Lockdep problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've ran into the lockdep problem: I'm hitting the condition at the
lockdep.c:2437:
       if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
                return 0;

What does it mean and how to overcome it? Dumbly increasing constants
at kernel/lockdep_internals.h didn't help.

The warning is pretty fatal for me because it happens when I'm locking
clocks lock, so when serial console output calls
clk_enable/clk_disable the kernel deadlocks.

-- 
With best wishes
Dmitry
