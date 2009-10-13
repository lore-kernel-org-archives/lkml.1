Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbZJMWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbZJMWyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934157AbZJMWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:54:36 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:49074 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933981AbZJMWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:54:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O+boJQWLSv9Np18An2tuK7aaeuB39SWd5cyTajmF7JM4+Msg8o7DlQNych+eyc/79tAUdCUXL2lrD8uQTnLvqX/5h85a+jo5E7TlWVYckehjUhUi3IOxf1YqPlRTG8qIHc6aQjcyhAZ9U8Qo5Ny8IgvtMtYo3ORkawbZnWiAy3w=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: utQHcTYVM1lOHcMdKyQA3BnjHBtv1By6kFJuC0.LNqsYgQx2XqFG.nFWtDl_3cqUcpPnmRETSsjRxbif.xZcMF79qt_xcOKJtDZ44djCXotr5g3TeHx22oMA4kwigxb0g0qHbYsbJ4sbRMhJ83hsBj2b6STsC_kn64LgwNkRzjjjYqzkI0GA1tnfPOgrX9btPf8EAB3uikznyn0hKpY2BYZosIxZHjVAjQcxX79W98EoV0wyLvI4Gy3Nj0i_idBkIcp.aoDMj8ZP5WpqQMYyAqiqUhiB2ZmuPDI6
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Date: Tue, 13 Oct 2009 15:53:58 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091010134814.0bac8624@bike.lwn.net> <200910131410.40305.david-b@pacbell.net> <20091013162819.02f53284@bike.lwn.net>
In-Reply-To: <20091013162819.02f53284@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131553.58804.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Jonathan Corbet wrote:
> On Tue, 13 Oct 2009 14:10:40 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Not real keen on this; see separate emails, and below.
> 
> OK, so the story I'm getting is that each driver needs to set up its
> own mechanism for obtaining GPIO numbers - it needs to create its own
> lookup mechanism.

Each driver needs its own *configuration* scheme.  Yes;
that's a very standard requirement.  ;)


> That's fine, I can do that; I just thought it made 
> sense to make use of the information that's already there.

It's not necessarily "there" though; or safe to use in this way,
should it happen to be present.


> Andrew, you might as well drop the patch.
> 
> (I'm less worried about the uniqueness side, BTW; it just means drivers
> need to create meaningful names for their GPIOs.)

I don't see how they *can* though ... unless they're dynamically
allocated using a scheme like "combine <this device's sysfs name>
with <token>".  Consider two PCI cards with two different GPIOs
for their "camera_active" LED... "camera_active" is meaningful,
but unusable because it's not unique.


Quick rule of thumb:  in absolutely *ANYTHING* to do with resource
lookup, see how the names/IDs are scoped.  That's the first place
problems show up.  If the scopes are not clearly defined, or there
is nothing to ensure uniqueness within that scope ... trouble.

- Dave


> 
> Thanks,
> 
> jon
> 
> 


