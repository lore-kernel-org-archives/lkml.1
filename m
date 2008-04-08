Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYDHVxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYDHVxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYDHVxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:53:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYDHVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:53:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=XIpEb1cRlDRpefy6xaP0znw3vIbnhkzPB6RCcN89ZE/87q6W0kEajgKJWngyIV3xS
	Y1no+8euqOG0GYM+ueuhA==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: frank@exit.com, linux-kernel@vger.kernel.org
In-Reply-To: <1207690074.4687.18.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
	 <20080331054404.78CDB26F8E9@magilla.localdomain>
	 <1206995072.14649.41.camel@bobble.smo.corp.google.com>
	 <20080402020707.151E126F8DC@magilla.localdomain>
	 <1207158164.11976.32.camel@bobble.smo.corp.google.com>
	 <20080402194836.4933026F98A@magilla.localdomain>
	 <1207168464.11976.48.camel@bobble.smo.corp.google.com>
	 <20080404231739.7E25126F8DC@magilla.localdomain>
	 <1207459608.94001.22.camel@jill.exit.com>
	 <20080407200804.5541926F992@magilla.localdomain>
	 <1207690074.4687.18.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 08 Apr 2008 14:52:41 -0700
Message-Id: <1207691561.4687.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 14:27 -0700, Frank Mayhar wrote:
> And, you guessed it, the invariant gets violated.  Apparently the passed
> task_struct isn't the same as "current" at this point.
> 
> Any ideas?  Am I checking the wrong thing?  If we're really not updating
> current then the task we are updating could very easily be running
> through __exit_signal() on another CPU.  (And while I wait for your
> response I will of course continue to try to figure this out.)

Found the exception.  do_fork() violates the invariant when it's
cranking up a new process.  Hmmm.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

