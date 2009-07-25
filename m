Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZGYUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZGYUKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZGYUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:10:34 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:55469 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZGYUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S4g3Zb4YodkSm2oJ3Sgwr1K7fPGqAucOgpQjgR4Lcj/ASUhJsiR0w1SOx4Cg39lix9
         c+2KwB8C885VdasH3Mo73YPZOqasVlGw5bcHLTdxzOiQt3iktUvYRNdunHZb0ZONzkhK
         fk/wdW3DQPaCTmooYcGjpmPQVNCGCAsg0Fzkg=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
In-Reply-To: <20090725174311.GB14062@dtor-d630.eng.vmware.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <20090725174311.GB14062@dtor-d630.eng.vmware.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 16:10:30 -0400
Message-Id: <1248552630.20372.21.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 10:43 -0700, Dmitry Torokhov wrote:
> Hi Arnaud,
> 
> On Sat, Jul 25, 2009 at 09:04:51AM -0400, Arnaud Faucher wrote:
> > Gets rid of the following warning:
> > Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> > 
> 
> Have you tested it with Suspend to disk? You are [potentially] breaking
> it since the new suspend and resume methods are not used by it, it calls
> freeze() and thaw() instead.
> 
> Rafael,
> 
> I wonder if PM core should automatically use suspend()/resume() in place of
> freeze()/thaw() when the latter pair is missing.
> 

By studying drivers/base/platform.c, suspend()/resume() are not called
when freeze()/thaw() are missing. So you're right, this patch breaks
something.

I am testing right now a new patch against hibernation.

