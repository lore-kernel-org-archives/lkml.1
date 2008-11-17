Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbYKQS6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbYKQS6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYKQS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:58:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:48470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYKQS6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:58:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gtgAL5CUrTfFk0SnrJBZMQT7v52VsegFqfuezCFs8yKxod16MLFYkwg7C1ol/aZ5QG
         Lz25kTTtMx/xxmD8Ah6a/haIs/K4fPKbAO/Kf4NQCt/245pWeQW0yvyTom8Y5s9X1EbM
         utRmM92aP42JZ8FZWwxWewhwDe0rVSg6fD2kA=
Message-ID: <4921BEC1.6090702@gmail.com>
Date: Mon, 17 Nov 2008 19:58:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return
 by registers
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com> <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com> <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com> <20081113085949.GG25479@elte.hu> <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com> <20081113094412.GL25479@elte.hu>
In-Reply-To: <20081113094412.GL25479@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
>> 2008/11/13 Ingo Molnar <mingo@elte.hu>:
>>> hm, function-exit is a quite bad name i think that tells nothing to
>>> the user. I like "function-cost tracer" because that tells the user
>>> what it's all about in the end.
>>>
>>> Or perhaps we could name it the "callgraph" tracer? (as opposed to the
>>> simpler function tracer which traces function entries) Note that we
>>> could use the output to build function call coverage graphs.
>> But you can build a call graph with the function tracer, that what 
>> does the script draw_trace.py in a bit loosely way for example.
> 
> yes, but not reliably so - there's no guaranteed callgraph structure. 
> With entry tracing we have entry+parent events, but especially across 
> longer callchains there's no truly guaranteed way to preserve the full 
> graph.


That's right, with the depth, we could have a more safe result for the call graph.

>> IMHO, function cost measurement or call graphs are particular uses 
>> that can be made of this engine. You can also use it to trace 
>> function return values for example.
> 
> yes. The mockup output has place for that.


The problem with this is that we don't know in advance if the return value fits in 32
or 64 bits...

>> So perhaps naming it by thinking on the purpose it could be use at 
>> most would be better that its "general" or "potential" purpose. I 
>> don't know...
> 
> i suggested "full-function" tracer name before, but that sounds a bit 
> quirky too.
> 
> Perhaps this should be the function-tracer, and the entry tracer would 
> be the function-entry tracer?
> 
> 	Ingo

I still wonder about the name we should choose...
Renaming function to function_entry seems to me a bit wrong because usual function
tracing happens in entry...

Why not two-pass function tracer?

