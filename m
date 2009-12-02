Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZLBRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZLBRe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZLBRe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:34:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:23878 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbZLBReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S4ekUknKGCdlnQfQaozsjOZv5uv2jBoqWgNKlWRlgvzzU78k1c238EhKzGcTZq8WI3
         GeUvfk66eAwNvkwS63khQ0JTEyRfalKoj6SpApcpo5g8MLW+OeBQ9CMzGtYAX2+EPHzu
         J3p4AICo67SDCA+WfVfYt78rzUzmnnXMCGNDE=
Subject: Maybe we can make no_console_suspend fine grained?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 19:34:26 +0200
Message-ID: <1259775266.4314.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the no_console_suspend isn't set, as soon as system begins
the suspend, at core printk level output is suppressed.

However, I want to have a simple and clean way to have all console
messages in the memory, because on my laptop memory isn't cleared on
reboots.

My first approach was just to put printk buffer at predefined address.
This wasn't favored by kernel developers, and even I myself found this
to be not such great solution.

Other approach is to create a console driver, however it won't be used
by printk ether during suspend and resume.

So, maybe we can add a flag that console should always be used,
regardless of no_console_suspend?
(This is the particular console is safe for that purpose)

I can even make the new console pm aware, thus make is possible to avoid
collisions between  every stage of the hibernation.
( Which happen today because resume kernel overwrites the printk
predefined buffer, and that is annoying because my system works just
fine now, but I want to keep that feature on)

Best regards,
Maxim Levitsky

