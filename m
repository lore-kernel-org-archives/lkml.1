Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbXF1C6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbXF1C6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbXF1C6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:58:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1109 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763338AbXF1C6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:58:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 19:58:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@gmail.com>,
       blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <Pine.LNX.4.64.0706271642340.3879@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0706271954030.5213@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com> 
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com> 
 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0706271921280.29060@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0706271135560.32731@alien.or.mcafeemobile.com>
 <1182982309.2737.9.camel@entropy> <Pine.LNX.4.64.0706271642340.3879@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Davide Libenzi wrote:

> On Wed, 27 Jun 2007, Nicholas Miell wrote:
> 
> > 1) euid is not sufficient, you need to store away arbitrary LSM
> > information and call LSM hooks to decide security equivalence. The same
> > applies to VServer or whatever other container system you use.
> 
> The EUID that is used now, can easily be any cookie. It can be an LSM 
> cookie (if LSM is active in the system). We don't do complex checks, like 
> group permission & Co.  We assume that if a UID-cookie had such data 
> available (or it generated it), it can have it back uncleared.

(looking through the LSM/SeLinux jungle)
Also, LSM/SeLinux could disable completely the feature, at request. Just 
assign a known-to-be-invalid UID to mm->owner_uid (passign through 
an(other) hook), and pages will never be recycled.



- Davide


