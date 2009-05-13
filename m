Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbZEMOpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbZEMOpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZEMOpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:45:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:18030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZEMOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=YitWI0TePTB4WP4WXS8IpLwuUGEHnnYjdHFqgjoPQqGvLHdod6eU3ye9pG8iFutwDV
         HZ8hgMMrpsWKDpjwc9bma/682V/3x36/SAaTu3+dg70H8hQSCbU/07FAj34uZ6OMQCGy
         aq0O8jz08aLSCC9DKMJrks4XrPI1EAMskw1pk=
Message-ID: <4A0ADCFA.6010508@gmail.com>
Date: Wed, 13 May 2009 10:45:14 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws> <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws> <4A0824C2.4000109@gmail.com> <4A0860D7.6010708@codemonkey.ws>
In-Reply-To: <4A0860D7.6010708@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig676C45F286BA9BF1CB8EB12C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig676C45F286BA9BF1CB8EB12C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> I specifically generalized my statement above because #1 I assume
>> everyone here is smart enough to convert that nice round unit into the=

>> relevant figure.  And #2, there are multiple potential latency sources=

>> at play which we need to factor in when looking at the big picture.  F=
or
>> instance, the difference between PF exit, and an IO exit (2.58us on x8=
6,
>> to be precise).  Or whether you need to take a heavy-weight exit.  Or =
a
>> context switch to qemu, the the kernel, back to qemu, and back to the
>> vcpu).  Or acquire a mutex.  Or get head-of-lined on the VGA models
>> IO. I know you wish that this whole discussion would just go away,
>> but these
>> little "300ns here, 1600ns there" really add up in aggregate despite
>> your dismissive attitude towards them.  And it doesn't take much to
>> affect the results in a measurable way.  As stated, each 1us costs
>> ~4%. My motivation is to reduce as many of these sources as possible.
>>
>> So, yes, the delta from PIO to HC is 350ns.  Yes, this is a ~1.4%
>> improvement.  So what?  Its still an improvement.  If that improvement=

>> were for free, would you object?  And we all know that this change isn=
't
>> "free" because we have to change some code (+128/-0, to be exact).  Bu=
t
>> what is it specifically you are objecting to in the first place?  Addi=
ng
>> hypercall support as an pv_ops primitive isn't exactly hard or complex=
,
>> or even very much code.
>>  =20
>
> Where does 25us come from?  The number you post below are 33us and
> 66us.  This is part of what's frustrating me in this thread.  Things
> are way too theoretical.  Saying that "if packet latency was 25us,
> then it would be a 1.4% improvement" is close to misleading.
[ answered in the last reply ]

> The numbers you've posted are also measuring on-box speeds.  What
> really matters are off-box latencies and that's just going to exaggerat=
e.

I'm not 100% clear on what you mean with on-box vs off-box.  These
figures were gathered between two real machines connected via 10GE
cross-over cable.  The 5.8Gb/s and 33us (25us) values were gathered
sending real data between these hosts.  This sounds "off-box" to me, but
I am not sure I truly understand your assertion.

>
>
> IIUC, if you switched vbus to using PIO today, you would go from 66us
> to to 65.65, which you'd round to 66us for on-box latencies.  Even if
> you didn't round, it's a 0.5% improvement in latency.

I think part of what you are missing is that in order to create vbus, I
needed to _create_ an in-kernel hook from scratch since there were no
existing methods. Since I measured HC to be superior in performance (if
by only a little), I wasn't going to chose the slower way if there
wasn't a reason, and at the time I didn't see one.  Now after community
review, perhaps we do have a reason, but that is the point of the review
process.  So now we can push something like iofd as a PIO hook instead.=20
But either way, something needed to be created.

>
>
> Adding hypercall support as a pv_ops primitive is adding a fair bit of
> complexity.  You need a hypercall fd mechanism to plumb this down to
> userspace otherwise, you can't support migration from in-kernel
> backend to non in-kernel backend.

I respectfully disagree.   This is orthogonal to the simple issue of the
IO type for the exit.  Where you *do* have a point is that the bigger
benefit comes from in-kernel termination (like the iofd stuff I posted
yesterday).  However, in-kernel termination is not strictly necessary to
exploit some reduction in overhead in the IO latency.  In either case we
know we can shave off about 2.56us from an MMIO.

Since I formally measured MMIO rtt to userspace yesterday, we now know
that we can do qemu-mmio in about 110k IOPS, 9.09us rtt.  Switching to
pv_io_ops->mmio() alone would be a boost to approximately 153k IOPS,
6.53us rtt.  This would have a tangible benefit to all models without
any hypercall plumbing screwing up migration.  Therefore I still stand
by the assertion that the hypercall discussion alone doesn't add very
much complexity.

>   You need some way to allocate hypercalls to particular devices which
> so far, has been completely ignored.

I'm sorry, but thats not true.  Vbus already handles this mapping.


>   I've already mentioned why hypercalls are also unfortunate from a
> guest perspective.  They require kernel patching and this is almost
> certainly going to break at least Vista as a guest.  Certainly Windows =
7.

Yes, you have a point here.

>
> So it's not at all fair to trivialize the complexity introduce here.=20
> I'm simply asking for justification to introduce this complexity.  I
> don't see why this is unfair for me to ask.

In summary, I don't think there is really much complexity being added
because this stuff really doesn't depend on the hypercallfd (iofd)
interface in order to have some benefit, as you assert above.  The
hypercall page is a good point for attestation, but that issue exists
already today and is not a newly created issue by this proposal.

>
>>> As a more general observation, we need numbers to justify an
>>> optimization, not to justify not including an optimization.
>>>
>>> In other words, the burden is on you to present a scenario where this=

>>> optimization would result in a measurable improvement in a real world=

>>> work load.
>>>    =20
>>
>> I have already done this.  You seem to have chosen to ignore my
>> statements and results, but if you insist on rehashing:
>>
>> I started this project by analyzing system traces and finding some of
>> the various bottlenecks in comparison to a native host.  Throughput wa=
s
>> already pretty decent, but latency was pretty bad (and recently got
>> *really* bad, but I know you already have a handle on whats causing
>> that).  I digress...one of the conclusions of the research was that  I=

>> wanted to focus on building an IO subsystem designed to minimize the
>> quantity of exits, minimize the cost of each exit, and shorten the
>> end-to-end signaling path to achieve optimal performance.  I also want=
ed
>> to build a system that was extensible enough to work with a variety of=

>> client types, on a variety of architectures, etc, so we would only nee=
d
>> to solve these problems "once".  The end result was vbus, and the firs=
t
>> working example was venet.  The measured performance data of this work=

>> was as follows:
>>
>> 802.x network, 9000 byte MTU,  2 8-core x86_64s connected back to back=

>> with Chelsio T3 10GE via crossover.
>>
>> Bare metal            : tput =3D 9717Mb/s, round-trip =3D 30396pps (33=
us
>> rtt)
>> Virtio-net (PCI)    : tput =3D 4578Mb/s, round-trip =3D 249pps (4016us=
 rtt)
>> Venet      (VBUS): tput =3D 5802Mb/s, round-trip =3D 15127 (66us rtt)
>>
>> For more details:  http://lkml.org/lkml/2009/4/21/408
>>  =20
>
> Sending out a massive infrastructure change that does things wildly
> differently from how they're done today without any indication of why
> those changes were necessary is disruptive.

Well, this is an unfortunate situation.  I had to build my ideas before
I could even know if they worked and therefore if they were worth
discussing.  So we are where we are because of that fact.  Anyway, this
is somewhat irrelevant here because the topic at hand in this thread is
purely the hypercall interface.  I only mentioned the backstory of vbus
so we are focused/aware of the end-goal.

>
> If you could characterize all of the changes that vbus makes that are
> different from virtio, demonstrating at each stage why the change
> mattered and what benefit it brought, then we'd be having a completely
> different discussion.

Splitting this up into small changes is already work is in progress.=20
Thats what we are discussing in this thread, afterall.

>   I have no problem throwing away virtio today if there's something
> else better.

I am not advocating this.  Virtio can (and does, though it needs testing
and backends written) run happily on top of vbus.  I am not even
advocating getting rid of the userspace virtio models.  They have a
place and could simply be run-time switched on or off, depending on the
user configuration.

>
> That's not what you've done though.  You wrote a bunch of code without
> understanding why virtio does things the way it does and then dropped
> it all on the list.

False.  I studied the system for the bottlenecks before I began.

>   This isn't necessarily a bad exercise, but there's a ton of work
> necessary to determine which things vbus does differently actually
> matter.  I'm not saying that you shouldn't have done vbus, but I'm
> saying there's a bunch of analysis work that you haven't done that
> needs to be done before we start making any changes in upstream code.
>
> I've been trying to argue why I don't think hypercalls are an
> important part of vbus from a performance perspective.   I've tried to
> demonstrate why I don't think this is an important part of vbus.

Yes, lets just drop them.  I will use PIO and not worry about non-x86.=20
I generally don't like to ignore issues like this where at least
conjecture indicates I should try to think ahead. However, its not worth
this headache to continue the conversation.  If anything, we can do the
IOoHC idea but lets just backburner this whole HC thing for now.

>   The frustration I have with this series is that you seem unwilling
> to compromise any aspect of vbus design.

Thats an unfair assertion.  As an example, I already started migrating
to PCI even though I was pretty against it in the beginning.  I also
conceded that the 350ns is possibly a non-issue if we don't care about
non-x86.

>   I understand you've made your decisions  in vbus for some reasons
> and you think the way you've done things is better, but that's not
> enough.  We have virtio today, it provides greater functionality than
> vbus does, it supports multiple guest types, and it's gotten quite a
> lot of testing.
Yes, and I admit that is a compelling argument against changing.

> It has its warts, but most things that have been around for some time d=
o.
>
>> Now I know you have been quick in the past to dismiss my efforts, and =
to
>> claim you can get the same results without needing the various tricks
>> and optimizations I uncovered.  But quite frankly, until you post some=

>> patches for community review and comparison (as I have done), it's jus=
t
>> meaningless talk.
>
> I can just as easily say that until you post a full series that covers
> all of the functionality that virtio has today, vbus is just
> meaningless talk.

That's a stretch.  Its a series that offers a new way to do a
device-model that we can re-use in multiple environments, and has
performance considerations specifically for software-to-software
interaction (such as guest/hypervisor) built into it.  It will also
hopefully support some features that we don't have today, like RDMA
interfaces, but that is in the future.

To your point, it is missing some features like live-migration, but IIUC
thats how FOSS works.  Start with an idea...If others think its good,
you polish it up together.  I don't believe KVM was 100% when it was
released either, or we wouldn't be having this conversation.

>   But I'm trying not to be dismissive in all of this because I do want
> to see you contribute to the KVM paravirtual IO infrastructure.=20
> Clearly, you have useful ideas.
>
> We can't just go rewriting things without a clear understanding of why
> something's better.  What's missing is a detailed analysis of what
> virtio-net does today and what vbus does so that it's possible to draw
> some conclusions.

This is ongoing.  For one, it hops through userspace which as I've
already demonstrated has a cost (that at least I care about).

>
> For instance, this could look like:
>
> For a single packet delivery:
>
> 150ns are spent from PIO operation
> 320ns are spent in heavy-weight exit handler
> 150ns are spent transitioning to userspace
> 5us are spent contending on qemu_mutex
> 30us are spent copying data in tun/tap driver
> 40us are spent waiting for RX
> ...
>
> For vbus, it would look like:
>
> 130ns are spent from HC instruction
> 100ns are spent signaling TX thread
> ...
>
> But single packet delivery is just one part of the puzzle.  Bulk
> transfers are also important.

Both of those are covered today (and, I believe, superior)...see the
throughput numbers in my post.

>   CPU consumption is important.

Yes, this is a good point.  I need to quantify this.  I fully expect to
be worse since one of the design points is that we should try to use as
much parallel effort as possible in the face of these multi-core boxes.

Note that this particular design decision is a attribute of venettap
specifically.  vbus itself doesn't force a threading policy.

>   How we address things like live migration
Yes, this feature is not started.  Looking for community help on that.

> , non-privileged user initialization

Nor is this.  I think I need to write some patches for configfs to get
there.


> , and userspace plumbing are all also important.

Basic userspace plumbing is complete, but I need to hook qemu into it

>
> Right now, the whole discussion around this series is wildly
> speculative and quite frankly, counter productive.

How?  I've posted tangible patches you can test today that show an
measurable improvement. If someone wants to investigate/propose an
improvement in general, how else would you do it so it is productive and
not speculative?=20

>   A few RTT benchmarks are not sufficient to make any kind of forward
> progress here.  I certainly like rewriting things as much as anyone
> else, but you need a substantial amount of justification for it that
> so far hasn't been presented.

Well, unfortunately for me the real interesting stuff hasn't been
completed yet nor articulated very well, so I can't fault you for not
seeing the complete picture.  In fact, as of right now we don't even
know if the "real interesting" stuff will work yet.  Its still being
hashed out.  What we do know is that the basic performance elements of
the design (in-kernel, etc) seemed to have made a substantial
improvement.  And more tweaks are coming to widen the gap.

>
>
> Do you understand what my concerns are and why I don't want to just
> switch to a new large infrastructure?

Yes.  However, to reiterate: its not a switch.  Its just another option
in the mix to have in-kernel virtio or not.  Today you have
emulated+virtio, tomorrow you could have emulate+virtio+kern_virtio

>
>
> Do you feel like you understand what sort of data I'm looking for to
> justify the changes vbus is proposing to make?  Is this something your
> willing to do because IMHO this is a prerequisite for any sort of
> merge consideration.  The analysis of the virtio-net side of things is
> just as important as the vbus side of things.

Work in progress.

>
>
> I've tried to explain this to you a number of times now and so far it
> doesn't seem like I've been successful.  If it isn't clear, please let
> me know.

I don't think this is accurate, and I don't really appreciate the
patronizing tone.

I've been gathering the figures for the kernel side of things, and last
we spoke, *you* were gathering all the performance data and issues in
qemu and were working on improvements.  In fact, last I heard, you had
reduced the 4000us rtt to 90us as part of that effort.  While I have yet
to see your patches, I was certainly not going to duplicate your work
here.  So to infer that I am somehow simply being obtuse w.r.t. your
request/guidance is a bit disingenuous.  That wasn't really what we
discussed from my perspective.

That said, I will certainly continue to analyze the gross path through
userspace, as I have done with "doorbell", because that is directly
relevant to my points.  Figuring out something like the details of any
qemu_mutex bottlenecks, on the other hand, is not.  I already contend
that the userspace path, at any cost, is just a waste.  Ultimately we
need to come back to the kernel anyway to do the IO, so there is no real
use in digging in deeper there IMO.  Just skip it and inject the IO
directly.

If you look, venettap is about the same complexity as tuntap.  Userpsace
is just acting as a marginal shim, so the arguments about the MMU
protection in userspace, etc, are of diminished value.  That said, if
you want to submit your patches to me that improve the userspace
overhead, I will include them in my benchmarks so we can gather the most
accurate picture possible.

The big question is: does the KVM community believe in in-kernel devices
or not?  If we don't, then the kvm+vbus conversation is done and I will
just be forced to maintain the kvm-connector in my own tree, or (perhaps
your preferred outcome?) let it die.  If we *do* believe in in-kernel,
then I hope that I can convince the relevant maintainers that vbus is a
good infrastructure to provide a framework for it.  Perhaps I need to
generate more numbers before I can convince everyone of this, and thats
fine.  Everything else beyond that is just work to fill in the missing
details.

If you and others want to join me in implementing things like a
virtio-net backend and adding live-migration support, that would be
awesome.  The choice is yours.  For now, the plan that Avi and I have
tentatively laid out is to work on making KVM more extensible via some
of this plumbing (e.g. irqfd) so that these types of enhancements are
possible without requiring "pollution" (my word, though Avi would likely
concur) of the KVM core.

Regards,
-Greg



--------------enig676C45F286BA9BF1CB8EB12C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoK3PoACgkQP5K2CMvXmqHFDwCgjLtiwWohOU5XCU8/QQci8hBP
HagAn08wfOhuj/7FlRthmmLfy//PlxkX
=aosk
-----END PGP SIGNATURE-----

--------------enig676C45F286BA9BF1CB8EB12C--
