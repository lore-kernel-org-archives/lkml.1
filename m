Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZG2QD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZG2QD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZG2QD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:03:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34401 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbZG2QDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:03:25 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 12:03:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQtdTlCAKSFKyC4a9gK5KM0idinfRqElIgFlHbkmg487O+zEcTK5Nbh48RrskDt7Ng
         aYd27oU3Ola0vnPWiea23cDN7GNXWH5O4A5/O5VVNsVWH4Kd7cmVkti0ByRLFq47pLUO
         MGSHRVGEKCZQduH1jFGBUYj4aj+UIRmmBFB5o=
MIME-Version: 1.0
In-Reply-To: <20090729173231.012d0b89@skybase>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
	 <20090729173231.012d0b89@skybase>
Date: Wed, 29 Jul 2009 16:36:46 +0100
Message-ID: <87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
From: Will Newton <will.newton@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dwalker@fifo99.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 4:32 PM, Martin
Schwidefsky<schwidefsky@de.ibm.com> wrote:

> Hmm, you have an object of type struct clocksource and you do
> cs->read(cs). If that is not clear enough then I don't know what is. We
> do that all over the place in the linux kernel. And I personally find
> these useless wrappers rather annoying. I don't like to have to jump to
> another place to find out that it just calls the read function of the
> object.

An argument for the helper is that it eases grepability. Sure you can
search for "->read" but that's going to turn up all kinds of
non-clocksource code as well. grep clocksource_read will get you
exactly what you want.
