Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbYALFhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbYALFhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYALFhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:37:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:18799 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYALFhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XLFHwqfodMzg8mj7uyD9GSNK74gb5JzYWzb2X0sVmebF/Qv3d94Gy+5ZmkNFBA1U70wObz3sGHdLWZNRZZVPDdjVdmjSuom3DzAugUACMfxNcepVNxTqofZODV6kFeZVGbP4EKcdiKwFk/ZUYpm5DFslO5bIfYeA2dZ5ARaNNwI=
Message-ID: <2c0942db0801112137k3f3f885ek212d5cbaecb7fea0@mail.gmail.com>
Date: Fri, 11 Jan 2008 21:37:18 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: questions on NAPI processing latency and dropped network packets
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <478654C3.60806@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478654C3.60806@nortel.com>
X-Google-Sender-Auth: 23e736aa56d7bbe9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 9:24 AM, Chris Friesen <cfriesen@nortel.com> wrote:
> After a recent userspace app change, we've started seeing packets being
> dropped by the ethernet hardware (e1000, NAPI is enabled).  The
> error/dropped/fifo counts are going up in ethtool:

(These are perhaps too obvious, but I didn't see the questions or
answers in the thread.)

Can you reproduce it with a simple userspace cpu hog? (Two, really,
one per cpu.)

Can you reproduce it with the newer e1000?

Can you reproduce it with git head?

If the answer to the first one is yes, the last no, then bisect until
you get a kernel that doesn't show the problem. Backport the fix,
unless the fix happens to be CFS. However, I suspect that your
userpace app is just starving the system from time to time.
