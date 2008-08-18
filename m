Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYHRWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYHRWg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYHRWgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:36:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:41507 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYHRWgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C+XVZvkFzuwlLPWRv5Awy6JKIukrsz3JIoLhqgil3y8nrtgfzbXDXj1InQW2QGhFVW
         03gQr1uWey6JlwJOqIKO4NBt8sZJfD4dPliseNWw/Zy9LxY3U7f7kh5ZUdZLeSrrbrxD
         5APmoVB+kPzDOwn1hEDmouR3Y8pjIFZ+4qhzg=
Message-ID: <86802c440808181536j2c214cc3k47e73fd147b4fee1@mail.gmail.com>
Date: Mon, 18 Aug 2008 15:36:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] net: forcedeth use pci_choose_state instead of PCI_D3hot - v2
Cc: "Jeff Garzik" <jgarzik@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Simon Arlott" <simon@fire.lp0.eu>
In-Reply-To: <200808190008.54743.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com>
	 <200808181222.49576.rjw@sisk.pl>
	 <86802c440808181450y5e908b6eo3e6d54bfca6f2d8f@mail.gmail.com>
	 <200808190008.54743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 3:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 18 of August 2008, Yinghai Lu wrote:
>> On Mon, Aug 18, 2008 at 3:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> >> > >  drivers/net/forcedeth.c |    8 +++++---
>> >> > >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >> > >
>> >> > > Index: linux-2.6/drivers/net/forcedeth.c
>> >> > > ===================================================================
>> >> > > --- linux-2.6.orig/drivers/net/forcedeth.c
>> >> > > +++ linux-2.6/drivers/net/forcedeth.c
>> >> > > @@ -5975,10 +5975,12 @@ static void nv_shutdown(struct pci_dev *
>> >> > >        if (netif_running(dev))
>> >> > >                nv_close(dev);
>> >> > >
>> >> > > -       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> >> > > -       pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>> >> > >        pci_disable_device(pdev);
>> >> > > -       pci_set_power_state(pdev, PCI_D3hot);
>> >> > > +       if (system_state == SYSTEM_POWER_OFF) {
>> >> > > +               if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
>> >> > > +                       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> >> > > +               pci_set_power_state(pdev, PCI_D3hot);
>> >> > > +       }
>> >> > >  }
>> >> > >  #else
>> >> > >  #define nv_suspend NULL
>> >> > >
>> >> >
>>
>> > Does the last patch work for you BTW?
>> >
>>
>> it works.
>
> OK, thanks for testing.
>
> I think we can use it as a quick fix for 2.6.27.  Do you agree?
>

yes

YH
