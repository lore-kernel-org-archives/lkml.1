Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXKLWfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXKLWfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXKLWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:35:11 -0500
Received: from ns.suse.de ([195.135.220.2]:42613 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbXKLWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:35:09 -0500
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Tue, 13 Nov 2007 09:35:01 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18232.54549.271030.214405@notabene.brown>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nfsd bugfixes
In-Reply-To: message from J. Bruce Fields on Monday November 12
References: <1194901503-23105-1-git-send-email-bfields@citi.umich.edu>
	<18232.52970.213438.902011@notabene.brown>
	<20071112221349.GA2645@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(CC: trimmed - as Bruce says: separate discussion)

On Monday November 12, bfields@fieldses.org wrote:
> On Tue, Nov 13, 2007 at 09:08:42AM +1100, Neil Brown wrote:
> > Calling nfsd_setuser an extra time does open us up for a very tiny
> > possibility of an ENOMEM at an awkward time.
> 
> Hm.  Could you give an example of possible consequences?

Just that you could get an ENOMEM in the middle of a NFSv4 COMPOUND.
I guess that should result in NFSERR_RESOURCE and we just hope the
client is able to cope and resend the remainder of the compound.
Though looking at the code, ENOMEM becomes nfserr_dropit... does that
mean the we would drop the whole request and the client would need to
resend, possibly duplicating non-idempotent portions?

Mainly, it just feels unclean.

> 
> (Though note this is somewhat of a separate discussion, since this
> particular patch doesn't add a call to nfsd_setuser().)

Hmm, you are right, we already call nfsd_setuser in both paths, you we
just adding the check for privileged port - doh ;-)

NeilBrown
