Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZGVRNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZGVRNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZGVRNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:13:34 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:41196 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753971AbZGVRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:13:33 -0400
X-Yahoo-Newman-Id: 232249.35461.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=opNYTTaO4/T8dX0tj1rBxlhvnWgIo+w+bQ73QSX1VNbUz/iMiO327inikz+JIglZGOQAcxzezCH8joV0FKra2N+sKyC9p0zofz871UAMHxPJ5VjkaXR53XXCJ9Py35e/zQoMR+yp7Aut3BHSfYq9p/fEw3lF8NT729ggrCBYcNE=  ;
X-YMail-OSG: b6moAlEVM1k8.pmesC0pXGE7EaIakF9dP6cjE_P31qnCsNdRha9nsXbUo4yglWLVXZ7u4b2Rn31HI58F0lwRs6mZAMNhNdl4q40r85OaP.jUT2AQHBmAUBnl3H.BS7bmfhgYgFccZuGXKV.SOEjk8Ip1pK7h85VoYHr3ToyK6Jir0ufD8kjAWfvYvBKYI59.XJLwKQzEPpiLXT.DPX0lB6_QPaco.A3IdKWSCAyF1ypKSAFpYKRS0uwetUSp3wiiZV94UaVa4M7.hAF1v0gUeVKVEASWMZWwAK7loTaBcf0vY0AfL1Nq
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 10:13:31 -0700
User-Agent: KMail/1.9.10
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <20090721113642.GC13286@sirena.org.uk> <20090722155811.GA2775@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907221830410.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221830410.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221013.32087.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Thomas Gleixner wrote:
> 
> > I do think this should be set up by the driver - the platform/arch code
> > can't be 100% certain what model of servicing interrupts driver will
> > chose, nor the driver can know whether arch code set things up for
> > threaded or classic interrupt handling.
> > 
> > Since handle_level_oneshot_irq requires drivers to use threaded IRQ
> > model (in absence of thread interrupt will never be unmasked) it would
> > be better if we did set it up automatically, right there in
> > request_threaded_irq(). This would reduce maintenance issues between
> > platform and driver code.
> 
> No, it's the wrong way round. 
> 
> The platform code sets up the platform devices. So there is no real
> good reason that the platform code does not know about the details.

Except for the "development board" family of exceptions to
such rules ... or the "Processor-on-Card" model, where the
same platform/card gets used in a variety of different
chassis configurations, with different peripherals.

It may not be possible to know *which* configuration is
being used at board setup time.  However it most certainly
is known by the time a driver is configuring.



