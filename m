Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXDVTal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXDVTal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDVTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:30:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030524AbXDVTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:30:40 -0400
Date: Sun, 22 Apr 2007 12:29:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Junio C Hamano <junkio@cox.net>
cc: Nicolas Pitre <nico@cam.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
In-Reply-To: <7vd51wmd1a.fsf@assigned-by-dhcp.cox.net>
Message-ID: <alpine.LFD.0.98.0704221225300.9964@woody.linux-foundation.org>
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net> <7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
 <7vvefonvdz.fsf@assigned-by-dhcp.cox.net> <7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221422250.28339@xanadu.home> <7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221431430.28339@xanadu.home>
 <alpine.LFD.0.98.0704221144250.9964@woody.linux-foundation.org>
 <7vy7kkmdtg.fsf@assigned-by-dhcp.cox.net>
 <7vd51wmd1a.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Apr 2007, Junio C Hamano wrote:
> 
> How about this as a replacement (hot off the press -- still
> running the tests).

Looks good, but..

> +		mode_t mode = umask(0);
> +
> +		umask(mode);
> +		mode = 0666 & ~mode;

I would really suggest just defaulting to

	mode = 0444 & ~mode;

since there simply is never any reason to allow a writable pack-file.

The fact that we have some tests that try to corrupt a pack-file is not 
really a reason. Just make them do "chmod +w" before corrupting it.

But your patch is an obvious improvement regardless, so I certainly don't 
think this is a *big* issue.

		Linus
