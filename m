Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZCCCh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZCCCh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCCChO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:37:14 -0500
Received: from n30.bullet.mail.mud.yahoo.com ([68.142.207.49]:22583 "HELO
	n30.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752399AbZCCChN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:37:13 -0500
X-Yahoo-Newman-Id: 751641.89587.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mwY8iI0yx3Z/l5vhf8M8YNWnCs+5YZA96AbIu5o+iHmkBOz6dWo8ZXhrBxjQ21TB558svMJCGQLgnZAgEFWQnN6tBUMSyuhZkzS51h3M2FXRZLUkXu23toKL+cDr6wXtDABioA2EDjhp1j5V1iaLXE84Oq3ZmUWLWtMi12XJ7R4=  ;
X-YMail-OSG: bb8q6G8VM1kqQ4DaoOv7NM_uvwExs3XCgND.nu.UG3RIKrGirG2Of2vohIb4Zf61N247VCrXtJiQocYxHZ7yeCx2qAhNQu2RMC7nBZCUKyJjTI4afbBTx4DmzL56IouOSwutpo0TNF3NqmavIdoGvFRJFsmiOG6ijefKZ0uo6VSN3IauLIrKyb3ZhtDh
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 18:37:08 -0800
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu>
In-Reply-To: <20090303004427.GA8638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903021837.08635.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Ingo Molnar wrote:
> > 
> > p.s. Note that those changes would still leave the
> >      lockdep bug around ... it will still be breaking
> >      various drivers that use normal IRQs, by forcibly
> >      enabling IRQF_DISABLED.
> 
> it's not a bug - and i think Peter explained that already. 

No.  But I did get a non-response that didn't include any
explanation, and relied totally on unfounded assertions
combined with the presumption that someday IRQF_DISABLED
will be forced on in all drivers.


> It's  
> not really breaking things either - we've had this for more than 
> 2 years.

I happened across two MMC host adapter drivers which it
broke.  They preceded the patch whereby lockdep changes
request_irq() semantics.  The drivers break only with
lockdep ... so platforms relying on those can't use lockdep.
No reason to think there aren't more such bugs lurking.

We also wasted quite a few months tracking down USB bugs
that were masked by that patch ... the indeterminacy of
IRQF_DISABLED behavior given IRQF_SHARED was hidden by
enabling lockdep.  Led to a lot of totally crapulous oops
traces, I assure you.

So ... it has most certainly broken things.  There has
seemed to be a bit of stick-fingers-in-ears going on, that
prevents hearing about such problems though.

- Dave



