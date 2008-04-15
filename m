Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYDONPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYDONPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYDONPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:15:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:27058 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYDONPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sQ4ZIGy9FyeD8XPEP3O3k9B271w0pSzu/BJb83B2UOPQnWMg8lhPQuTxjMhcbxsVCL1DYqVs7GAW5T/6svMuN1fxcTIZ9CPRuka8qvb4zHpReYjgfFOn2owGZ51yEVONwW4HaykUyp/z2Vs9SOVDu8SFrFf4pN/+pa9XMtLd+JA=
Message-ID: <e2e108260804150615t577dd687u9c093e4f8a9ab923@mail.gmail.com>
Date: Tue, 15 Apr 2008 15:15:32 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] Replace completions with semaphores
Cc: "Andi Kleen" <andi@firstfloor.org>, "Roland Dreier" <rdreier@cisco.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Matthew Wilcox" <matthew@wil.cx>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <1208249088.7124.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411210022.GJ11962@parisc-linux.org>
	 <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>
	 <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
	 <4803AD91.5020001@firstfloor.org>
	 <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>
	 <1208242017.7053.4.camel@lappy>
	 <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com>
	 <1208249088.7124.7.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>  Also things like lockdep are a real help to a lot of developers - loads
>  of locking bugs never make it into the kernel because of it.

I agree that lockdep is a real help for kernel developers. But please
keep in mind that locking order checking has its limitations. While
locking order checking can detect certain very important classes of
deadlocks, it can't detect all classes of possible deadlocks. Consider
e.g. the example mentioned by Roland Dreier, where semaphores are used
to count the number of elements in a queue. Deadlocks triggered by
waiting for a certain semaphore value can't be detected by
lockdep-style algorithms. And renaming semaphores into something else
won't help.

Bart.
