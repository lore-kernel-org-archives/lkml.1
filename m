Return-Path: <linux-kernel-owner+w=401wt.eu-S1031169AbXDQQdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031169AbXDQQdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030797AbXDQQdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:33:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13797 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030775AbXDQQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:33:36 -0400
X-IronPort-AV: i="4.14,419,1170662400"; 
   d="scan'208"; a="136863119:sNHT43824438"
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [CRYPTO] is it really optimized ?
X-Message-Flag: Warning: May contain useful information
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	<E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	<38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	<adairbv57s2.fsf@cisco.com>
	<38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 09:33:21 -0700
In-Reply-To: <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com> (Francis Moreau's message of "Tue, 17 Apr 2007 18:14:58 +0200")
Message-ID: <ada7isb3qr2.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2007 16:33:22.0078 (UTC) FILETIME=[1D14DBE0:01C7810E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I wonder if there's some way you can cache the last caller and reload
 > > the key lazily (only when it changes).
 > 
 > yes something that allows crypto drivers to detect if the key has
 > changed would be good.

It seems trivial to keep the last key you were given and do a quick
memcmp in your setkey method to see if it's different from the last
key you pushed to hardware, and set a flag if it is.  Then only do
your set_key() if you have a new key to pass to hardware.

I'm assuming the expense is in the aes_write() calls, and you could
avoid them if you know you're not writing something new.

 - R.
