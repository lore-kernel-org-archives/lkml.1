Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYKEAOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYKEAOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKEAOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:14:16 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:45240 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYKEAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Xadj7vEflaNr2rv9Y7JO+/TxAe1TGDI1r0n370zHXu9lyAlMHupBqjlmfks0pzIRW0
         DCuoklobbeduLqi/0wAO9J9Y8wZfQGIxUOI/QrRUbHgwn8vO3gau/jNx49tVwdD/I+PF
         BrKtGNAg7hBCU+URyhAWjTekwWQBN4Z2TSLQw=
Message-ID: <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
Date: Tue, 4 Nov 2008 16:14:14 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
In-Reply-To: <20081104224510.GA7672@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104224510.GA7672@mit.edu>
X-Google-Sender-Auth: da12f019dc6cf386
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 2:45 PM, Theodore Tso <tytso@mit.edu> wrote:
> I've opened a Kernel Bug to track this regression:
>
>     http://bugzilla.kernel.org/show_bug.cgi?id=11951
>
> My fileserver boots under 2.6.27, but it is failing to boot on
> 2.6.28-rc2.  It took me a while to bisect, so after I finished the
> bisection, I retested with the latest mainline
> (v2.6.28-rc3-54-g75fa677), and the problem still shows up.
>
> Essentially, the system panics in early boot, resulting in multiple
> oops.  I finally was able get the very first oops, and the image of
> that oops can be found here:
>
> http://thunk.org/tytso/2.6.27-regress/92b29b8/IMG_0331.JPG
>
> From the console snapshot, it looks like two CPU simultaneously
> OOPS'ed with a:
>
> BUG: unable to handle kernel NULL dereference at 00000000
> BUG: unable to handle kernel NULL dereference at 00000038
>
> On the stack is "scheduler_tick+0x83/0x15f"
>
> When doing a bisection, the last good commit (i.e., the last one which
> I can boot on my system) is git id: d6c88a50 (which preceeds 2.6.28-rc1).
>
> The first bad git ID is:
>
> commit d6c88a507ef0b6afdb013cba4e7804ba7324d99a
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Oct 15 15:27:23 2008 +0200
>
>    genirq: revert dynarray
>
>    Revert the dynarray changes. They need more thought and polishing.
>
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> ... but in fact, the failure is different from the above messages.
> The failure is also in early boot, but the oops message is quite
> different:

please check http://lkml.org/lkml/2008/11/4/431

YH
