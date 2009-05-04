Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZEDQVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZEDQVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZEDQUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:20:53 -0400
Received: from gate.in-addr.de ([212.8.193.158]:49552 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752586AbZEDQUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:20:52 -0400
Date: Mon, 4 May 2009 18:20:11 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090504162011.GO17956@suse.de>
References: <20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> <20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> <20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> <49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> <ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-05-02T23:47:03, Kay Sievers <kay.sievers@vrfy.org> wrote:

> It is not about missing events, it is about the bootstrap step we
> would like to avoid. Buffering events, or reading all device
> information from sysfs at this stage introduces a hard checkpoint,
> where we need to bring a process up process these events and create
> nodes for them. Only after that we can start other things in userspace
> which depend on a working /dev, and with the kernel populated one, we
> can just go ahead.

So if udevd was present before the kernel started scanning devices this
would not be as much of a problem, would it? 

(Couldn't udevd trigger the device scan? Could it be started so early as
for this not to matter?)

And isn't part of the problem that you have a choke point in the
dependency graph - namely "/dev working" as a predicate for running
certain services/scripts - instead of more fine-grained dependencies for
just the devices they need?


Regards,
    Lars

-- 
SuSE Labs, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

