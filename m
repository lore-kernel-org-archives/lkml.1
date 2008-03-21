Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYCUWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYCUWAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbYCUV7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:59:55 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:40515 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756938AbYCUV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:59:54 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 17:59:54 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xSDGCJkiqKSfsDEsY6jYmGnycypPQNdZdgxv36H79ZT/kNFu2gT/RMQjVpL12SoBQWcDlyovymelH71Qm60PvivBTfzePA/laazF4dyRhkd1o270HTAJlhWLsUY4S4ZUK1AMDKQ60mmMQtX5er/0fr4UdceO7WoAHUznDkc8GIM=;
X-YMail-OSG: otLJaOsVM1mGn0YF6CCwxxP9AJ7tuRHrnX0zekdld62JTqTqLlp0JTVA_7gQnjtc5RzERg--
Date: Fri, 21 Mar 2008 14:48:02 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 3/3] EDAC Add e752x parameter for sysbus_parity selection
To: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com
Cc: Peter Tyser <ptyser@xes-inc.com>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
In-Reply-To: <20080321143524.318d002a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <920687.59522.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Tyser,

can you look into this, as it is your requirement, for a possible better solution with those on
the CC list? 

Thanks

Thanks Andrew for the notice.

doug t



--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 19 Mar 2008 14:55:59 -0600
> dougthompson@xmission.com wrote:
> 
> > +/* Setup system bus parity mask register.
> > + * Sysbus parity supported on:
> > + *   e7320/e7520/e7525 + Xeon
> > + *   i3100 + Xeon/Celeron
> > + * Sysbus parity not supported on:
> > + *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
> > + */
> > +static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
> > +{
> > +	char *cpu_id = cpu_data(0).x86_model_id;
> > +	struct pci_dev *dev = pvt->dev_d0f1;
> > +	int enable = 1;
> > +
> > +	/* Allow module paramter override, else see if CPU supports parity */
> > +	if (sysbus_parity != -1) {
> > +		enable = sysbus_parity;
> > +	} else if (cpu_id[0] &&
> > +		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
> > +		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
> > +		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
> > +		e752x_printk(KERN_INFO, "System Bus Parity not "
> > +			     "supported by CPU, disabling\n");
> > +		enable = 0;
> > +	}
> > +
> > +	if (enable)
> > +		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0000);
> > +	else
> > +		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0309);
> > +}
> 
> Is that the best way of working out whether the CPU supports system bus
> parity?  We do have cpu capability infrastructure in x86 core and I'd have
> thought it would be better for x86 core to work this out, set the suitable
> flag and have clients (ie: EDAC) test that flag?
> 
> 


W1DUG
