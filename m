Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYEFSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYEFSex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYEFSel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:34:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:33155 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYEFSej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q0H1jEXUWrPRfXCS3cXkgtUbKWydqjulmqLNS27AJHxd9ZwgdmwnwylaM7P0IFH45ZEYzjeB/RRAkss7nLhUolPXsaDXKY7PNeO4RRBOqkUyFhf9G+yp5zSI2OsoopDf9cSamkmoPvDDcy8DH4eZFS60n4812PvJmQqizRrMmpI=
Message-ID: <86802c440805061134y21fbb2a3s872c41c522b9f49f@mail.gmail.com>
Date: Tue, 6 May 2008 11:34:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4820A401.1040105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805061038.58023.yhlu.kernel@gmail.com>
	 <200805061041.40047.yhlu.kernel@gmail.com>
	 <482099E6.5060208@zytor.com>
	 <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>
	 <4820A401.1040105@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 11:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > >  If the mptable should be modified, it should be copied to kernel memory
> and
> > > modified there.  Modifying it in-place is both unsafe and, in general,
> > > simply will not work.
> > >
> >
> > but
> >
> >         * 1) Scan the bottom 1K for a signature
> >         * 2) Scan the top 1K of base RAM
> >         * 3) Scan the 64K of bios
> >         */
> >        if (smp_scan_config(0x0, 0x400, reserve) ||
> >            smp_scan_config(639 * 0x400, 0x400, reserve) ||
> >            smp_scan_config(0xF0000, 0x10000, reserve))
> >                return;
> >
> > and all these areas are reserved already.
> >
> > wonder if we could only modify mpf->mpf_physptr to point to another
> > mpc and reuse mpf?
> >
> >
>
>  Obviously, if you have already modified a table, you should save a pointer
> to it, and not rely on the kernel scanning later.

that modified mptable is for second kernel that is kexeced.

YH
