Return-Path: <linux-kernel-owner+w=401wt.eu-S1946090AbXBPTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946090AbXBPTxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946093AbXBPTxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:53:21 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2410 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946090AbXBPTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:53:19 -0500
Date: Fri, 16 Feb 2007 19:52:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Message-ID: <20070216195256.GE2572@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <200702162045.58857.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702162045.58857.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Feb 16, 2007 at 08:45:58PM +0100, Arnd Bergmann wrote:
> On Friday 16 February 2007 13:10, Eric W. Biederman wrote:
> > To do this I believe will require a s/unsigned int irq/struct irq_desc *irq/
> > throughout the entire kernel.  Getting the arch specific code and the
> > generic kernel infrastructure fixed and ready for that change looks
> > like a pain but pretty doable.
> 
> We did something like this a few years back on the s390 architecture, which
> happens to be lucky enough not to share any interrupt based drivers with
> any of the other architectures.

What you're proposing is looking similar to a proposal I put forward some
4 years ago, but was rejected.  Maybe times have changed and there's a
need for it now.

Message attached.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

--uQr8t48UFsdbeI+V
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <rmk@arm.linux.org.uk>
Envelope-to: rmk@arm.linux.org.uk
Delivery-date: Sun, 08 Jun 2003 00:05:30 +0100
Received: from caramon.arm.linux.org.uk ([3ffe:8260:2002:1:a00:2bff:fe95:1d7b])
	by flint.arm.linux.org.uk with asmtp (Exim 4.14)
	id 19Omkc-0004S9-8w
	for rmk@arm.linux.org.uk; Sun, 08 Jun 2003 00:05:30 +0100
Received: from vger.kernel.org ([209.116.70.75])
	by caramon.arm.linux.org.uk with esmtp (Exim 4.14)
	id 19Omka-0008SL-2F
	for rmk@arm.linux.org.uk; Sun, 08 Jun 2003 00:05:28 +0100
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:48909 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263938AbTFGWvu (ORCPT <rfc822;linux-arch@vger.kernel.org>);
	Sat, 7 Jun 2003 18:51:50 -0400
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.14)
	id 19OmkT-0008SG-D1; Sun, 08 Jun 2003 00:05:21 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.14)
	id 19OmkR-0004RM-W4; Sun, 08 Jun 2003 00:05:19 +0100
Date: Sun, 8 Jun 2003 00:05:19 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: linux-arch@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] IRQ API
Message-ID: <20030608000519.A15604@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
X-Message-Flag: Your copy of Microsoft Outlook is vulnerable to viruses. See www.mutt.org for more details.
Sender: Russell King <rmk@arm.linux.org.uk>
X-Check-HTML: true
X-Keywords: 
X-UID: 18

Hi,

I've recently received an updated development system from ARM Ltd,
which has caused me to become concerned about whether the existing
IRQ infrastructure for the ARM architecture is really up to the job
of handling the developments which will occur over the 2.6 lifetime.
Essentially we're going to be seeing the emergence of vectored
interrupt controllers, and knowing hardware designers, they'll
continue the practice of chaining interrupt controllers (which is
pretty common on ARM today.)  I have some hardware here today which
has a vectored interrupt controller chained after two non-vectored
controllers.  This vectored interrupt controller is on an add-on
card, and so has no fixed address space and no fixed IRQ numbering.

Rather than having the job of rewriting this code during 2.6, I'd much
prefer to get something sorted, even if it is ARM only before 2.6.

I believe that there are some common problems with the existing API
which have been hinted at over the last few days, such as large
NR_IRQS.  As such, I think it would be a good idea to try to thrash
this issue out and get something which everyone is happy with.

Additionally, I've added Alan's "reserve then hook" idea to the API;
I seem to remember there is a case in IDE which needs something like
this.

Please note that what I am proposing is not to strip out the existing
API between now and 2.7; what I am proposing is a structure for 2.7
which can optionally be implemented by architectures and used in
architecture specific drivers now if they feel they would benefit
from it.

Comments? (other than "wtf are you thinking about this so close to 2.6,
are you mad" 8))


			Linux Interrupt API
			===================

		Russell King <rmk@arm.linux.org.uk>

The Linux Interrupt API provides a flexible mechanism to handle and
control interrupts within the kernel.  The design requirements for
this API are:

- must have as little overhead as possible for commodity hardware
- must be easy and obvious to use
- must allow complex multi-level interrupt implementations to exist
  transparently to device drivers
- must be compatible with the existing API

Essentially, this means that implementation of the existing API must
be simple.

------------------------------------------------------------------------------

The API.
========

struct irq {
	/* architecture defined information */
	/* must not be dereferenced by drivers */
	/* eg, x86's irq_desc_t or sparc64's struct ino_bucket */
};

#define NO_IRQ	<architecture-defined-int-constant>

/**
 *	irq_get - increment reference count on the IRQ descriptor
 *	@irq: interrupt descriptor
 *
 *	IRQ descriptor reference counting is mandatory for
 *	implementations which provide dynamically allocated IRQ
 *	descriptors.  statically allocated IRQ descriptor
 *	implementations may define these to be no-ops.
 */
struct irq *irq_get(struct irq *irq);

/**
 *	irq_put - decrement reference count on IRQ descriptor
 *	@irq: interrupt descriptor
 *
 *	Decrement the reference counter in an IRQ descriptor.
 *	If the reference counter drops to zero, the IRQ descriptor
 *	will be freed.
 *
 *	IRQ descriptor reference counting is mandatory for
 *	implementations which provide dynamically allocated IRQ
 *	descriptors.  statically allocated IRQ descriptor
 *	implementations may define these to be no-ops.
 */
void irq_put(struct irq *irq);

/**
 *	irq_disable_nosync - disable an irq without waiting
 *	@irq: Interrupt descriptor to disable
 *
 *	Disable the selected interrupt line.  Disables and Enables are
 *	nested.
 *	Unlike irq_disable(), this function does not ensure existing
 *	instances of the IRQ handler have completed before returning.
 *
 *	This function may be called from IRQ context.
 */
void irq_disable_nosync(struct irq *irq);

/**
 *	irq_disable - disable an irq and wait for completion
 *	@irq: Interrupt descriptor to disable
 *
 *	Disable the selected interrupt line.  Enables and Disables are
 *	nested.
 *	This function waits for any pending IRQ handlers for this interrupt
 *	to complete before returning. If you use this function while
 *	holding a resource the IRQ handler may need you will deadlock.
 *
 *	This function may be called - with care - from IRQ context.
 */
void irq_disable(struct irq *irq);

/**
 *	irq_enable - enable the specified IRQ source.
 *	@irq: Interrupt descriptor to enable
 *
 *	Undoes the effect of one call to irq_disable().  If this
 *	matches the last disable, processing of interrupts on this
 *	IRQ line is re-enabled.
 *
 *	This function may be called from IRQ context.
 */
void irq_enable(struct irq *irq);

/**
 *	irq_request - request the use of an IRQ.
 *	@irq: irq descriptor
 *	@irqflags: interrupt type flags (SA_SHIRQ, SA_INTERRUPT)
 *	@devname: ascii name for the claiming device
 *	@dev_id: A cookie passed back to the handler function
 *
 *	Request use of an interrupt line.  We don't actually hook
 *	the interrupt immediately; any resources necessary are
 *	allocated.  As such, this function may sleep.
 *
 *	This function takes a reference on the IRQ descriptor.
 */
int irq_request(struct irq *irq, unsigned long irqflags, char *devname, void *dev_id);

/**
 *	irq_register - register an interrupt function to be called
 *	@irq: interrupt descriptor
 *	@handler: interrupt handler function
 *	@dev_id: A cookie passed back to the handler function
 *
 *	Hook a previously registered interrupt line.  If the
 *	interrupt has not been hooked by this instance, we fail.
 */
int irq_register(struct irq *irq,
		 irqreturn_t (*handler)(void *dev_id, struct pt_regs *),
		 void *dev_id);

/**
 *	irq_release - free an interrupt line
 *	@irq: interrupt descriptor
 *	@dev_id: device identity to free.
 *
 *	Remove an interrupt handler. The handler is removed and if the
 *	interrupt line is no longer in use by any driver it is disabled.
 *	On a shared IRQ the caller must ensure the interrupt is disabled
 *	on the card it drives before calling this function. The function
 *	does not return until any executing interrupts for this IRQ
 *	have completed.
 *
 *	We drop a reference on the IRQ descriptor, and therefore may be
 *	freed by irq_release.
 *
 *	This function must not be called from interrupt context.
 */
void irq_release(struct irq *irq, void *dev_id);

/**
 *	irq_name - fill in and return the name of an IRQ
 *	@buf: buffer to fill with name
 *	@size: size of buffer
 *	@irq: irq descriptor
 *
 *	Create an ASCII name of an IRQ and place it in buf.
 *	Returns the address of the buffer.
 */
const char *irq_name(char *buf, size_t size, struct irq *irq);

/**
 *	irqisa_to_desc - convert an ISA interrupt number to irq descriptor
 *	@irqnr: ISA interrupt number
 *
 *	Return the IRQ descriptor for a given "ISA" interrupt number.
 *	Returns NULL if the "ISA" interrupt number is invalid.
 *
 *	The returned IRQ has been "gotten" so irq_put will be required
 *	to balance once the IRQ is no longer required.
 */
struct irq *irqisa_to_desc(int irqnr);

/**
 *	irqdesc_to_isa - convert an irq descriptor to an ISA interrupt number
 *	@irq: Interrupt descriptor
 *
 *	Returns the "ISA" interrupt number given an interrupt
 *	descriptor.  Other interrupts return NO_IRQ.
 */
int irqdesc_to_isa(struct irq *irq);

/**
 *	irq_probe_on - begin an interrupt autodetect
 *
 *	Commence probing for an interrupt. The interrupts are scanned
 *	and a cookie is returned.
 *
 *	The IRQ probe semaphore is taken prior to the commencement of
 *	interrupt probing.
 */
void *irq_probe_on(void);

/**
 *	irq_probe_mask - scan a bitmap of interrupt lines
 *	@cookie: cookie returned from irq_probe_on
 *
 *	Scan the ISA bus interrupt lines and return a bitmap of
 *	active interrupts. The interrupt probe logic state is then
 *	returned to its previous value.
 *
 *	The IRQ probe semaphore is released and the cookie destroyed;
 *	irq_probe_off must not be called.
 */
unsigned int irq_probe_mask(void *cookie);

/**
 *	irq_probe_off - end an interrupt autodetect
 *	@cookie: cookie returned from irq_probe_on
 *
 *	Scans the unused interrupt lines and returns the irq descriptor
 *	which appears to have triggered the interrupt. If no interrupt
 *	was found then NULL is returned.
 *
 *	The IRQ probe semaphore is released and the cookie destroyed;
 *	irq_probe_off must not be called.
 */
struct irq *irq_probe_off(void *cookie);

------------------------------------------------------------------------------

Example backwards-compatible IRQ code.
======================================

The following example code shows the expected back-compat code required
for the x86 architecture.  Since x86 uses a fixed table of interrupts,
this is relatively straight forward and simple.


static inline void disable_irq_nosync(int inr)
{
	irq_disable_nosync(irq_desc + inr);
}

static inline void disable_irq(int inr)
{
	irq_disable(irq_desc + inr);
}

static inline void enable_irq(int inr)
{
	irq_enable(irq_desc + inr);
}

static inline int request_irq(int inr,
			      irqreturn_t (*handler)(int, void *, struct pt_regs *),
			      unsigned long irqflags,
			      const char * devname,
			      void *dev_id)
{
	struct irq *irq = irq_desc + inr;
	int ret;

	ret = irq_request(irq, irqflags, devname, dev_id);
	if (ret == 0) {
		/*
		 * irq_register_legacy is only implemented for
		 * implementations providing this compatible
		 * interface.
		 */
		ret = irq_register_legacy(irq, handler, dev_id);
		if (ret)
			irq_release(irq, dev_id);
	}
	return ret;
}

static inline void free_irq(int inr, void *dev_id)
{
	irq_release(irq_desc + inr, dev_id);
}

static inline unsigned long probe_irq_on(void)
{
	return (unsigned long)irq_probe_on();
}

static inline unsigned int probe_irq_mask(unsigned long mask)
{
	return irq_probe_mask((void *)mask);
}

static inline unsigned int probe_irq_off(unsigned long mask)
{
	struct irq *irq = irq_probe_off((void *)mask);

	return irq ? irq - irq_desc : 0;
}

				- o O o -

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html


--uQr8t48UFsdbeI+V--
