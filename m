Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZCUU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZCUU0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZCUU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:26:38 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57216 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZCUU0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:26:37 -0400
Message-ID: <49C54D60.80306@cosmosbay.com>
Date: Sat, 21 Mar 2009 21:26:08 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
References: <20090318215812.15496a86@infradead.org>	<20090319085628.GA6167@in.ibm.com>	<20090319071841.63334eff@infradead.org>	<20090320020750.GA6807@linux.vnet.ibm.com>	<20090319202032.4c971d92@infradead.org>	<20090320044541.GE6807@linux.vnet.ibm.com>	<20090320065058.65d01771@infradead.org>	<20090320143104.GA6698@linux.vnet.ibm.com>	<20090320111354.679ab53d@infradead.org>	<20090321012746.GM6698@linux.vnet.ibm.com> <20090321125115.0a76ac27@infradead.org>
In-Reply-To: <20090321125115.0a76ac27@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 21 Mar 2009 21:26:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> On Fri, 20 Mar 2009 18:27:46 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
>> On Fri, Mar 20, 2009 at 11:13:54AM -0700, Arjan van de Ven wrote:
>>> On Fri, 20 Mar 2009 07:31:04 -0700
>>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>>>> that'd be throwing out the baby with the bathwater... I'm
>>>>> trying to use the other cpus to do some of the boot work (so
>>>>> that the total goes faster); not using the other cpus would be
>>>>> counter productive to that. (As is just sitting in
>>>>> synchronize_rcu() when the other cpu is working.. hence this
>>>>> discussion ;-)
>>>> OK, so you are definitely running multiple CPUs when the offending
>>>> synchronize_rcu() executes, then?
>>> absolutely. 
>>> (and I'm using bootgraph.pl in scripts to track who's stalling etc)
>>>> If so, here are some follow-on questions:
>>>>
>>>> 1.	How many synchronize_rcu() calls are you seeing on the
>>>> 	critical boot path
>>> I've seen only this (input) one to take a long time
>> Ouch!!!  A -single- synchronize_rcu() taking a full second???  That
>> indicates breakage.
>>
>>>>  and what value of HZ are you running?
>>> 1000
>> K, in absence of readers for RCU_CLASSIC, we should see a handful
>> of milliseconds for synchronize_rcu().
> 
> I've attached an instrumented bootgraph of what is going on;
> the rcu delays are shown as red blocks inside the regular functions
> as they initialize......
> 
> (svg can be viewed with inkscape, gimp, firefox and various other tools)
> 
> 

Interesting stuff...

I thought you mentioned i2c drivers being source of the udelays(),
 but I cant see them in this svg, unless its async_probe_hard ?

