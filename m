Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZEPDXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZEPDXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 23:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZEPDW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 23:22:57 -0400
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:44724 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755390AbZEPDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 23:22:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dQBJxskyedw5H7vlXfyw7oz/Y9rrK6wSflPMfhyXrTlhSf/8g7gQRruoKPmhCusjdjgOAjLhutlDkAKkRTG6nitSMxpONZdKW46OTdFjYzcuirShXveZIVyrbViQ0LQP;
Date: Fri, 15 May 2009 20:22:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090515202250.0f1218ef@jbarnes-g45>
In-Reply-To: <4A0DFF78.6000501@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
	<20090513133021.GA7277@elte.hu>
	<4A0ADBA2.2020300@goop.org>
	<20090515182757.GA19256@elte.hu>
	<4A0DCC11.10307@goop.org>
	<m1my9ex818.fsf@fess.ebiederm.org>
	<4A0DFF78.6000501@goop.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 16:49:12 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Eric W. Biederman wrote:
> >> /proc/mtrr is in wide use today.  It may be planned for
> >> obsolescence, but there's no way you can claim its obsolete today
> >> (my completely up-to-date F10 X server is using it, for example).
> >> We don't break oldish usermode ABIs in new kernels.
> >>     
> >
> > Sure it is.  There is a better newer replacement.  It is taking a
> > while to get userspace transitioned but that is different.
> > Honestly I am puzzled why that it but whatever.
> >   
> 
> There's no mention in feature-removal-schedule.txt.
> 
> >> Besides, the MTRR code is also a kernel-internal API, used by DRM
> >> and other drivers to configure the system MTRR state.  Those
> >> drivers will either perform badly or outright fail if they can't
> >> set the appropriate cachability properties. That is not obsolete
> >> in any way. 
> >
> > There are about 5 of them so let's fix them.
> >   
> 
> Well, I count at least 30+, but anyway.
> 
> > With PAT we are in a much better position both for portability and
> > for flexibility.
> >   
> 
> PAT is relatively recent, and even more recently bug-free.  There are 
> many people with processors which can't or won't do PAT; what's the
> plan to support them?  Just hit them with a performance regression?
> Or wrap MTRR in some other API?
> 
> > Is it possible to fix PAT and get that working first.   That is
> > very definitely the preferend API.
> >   
> 
> Sure, when available.  We're sorting out the details for Xen, but
> even then it may not be available, either because we're running on an
> old version of Xen, or because some other guest is using PAT
> differently.
> 
> But I honestly don't understand the hostility towards 120 lines of
> code to make an interface (albeit legacy/deprecated/whatever) behave
> in an expected way.

FWIW I think supporting the MTRR API in Xen makes sense.  There's a lot
of old code out there that wants it; would be nice if it mostly worked,
especially at such a minimal cost.  It's taken awhile to get PAT going
(and there are still issues here and there) so having the MTRR stuffa
available is awfully nice.

-- 
Jesse Barnes, Intel Open Source Technology Center
