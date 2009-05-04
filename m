Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZEDXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZEDXEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZEDXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:04:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:34858 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZEDXEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:04:36 -0400
Date: Mon, 4 May 2009 19:03:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>,
       Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504230357.GI6766@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chris Friesen <cfriesen@nortel.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Matthew Wilcox <matthew@wil.cx>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
	Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	LKML <linux-kernel@vger.kernel.org>,
	Olivier Galibert <galibert@pobox.com>
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FF55D5.6060103@nortel.com> <m1k54wal0j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
> 
> > That's for the maintainers to decide.  If they agree it has worth, maybe
> > it's a good idea to answer "How".
> 
> Al and Christoph said essentially the same thing and they generally
> are considered the general area filesystem maintainers.

Ultimately the folks that is will be primarily making this decision is
Ogawa Hirofumi-san, as the FAT/VFAT maintainer, and Linus Torvalds, of
course.  So I'm not sure this thread is actually all that productive,
unless we can move it back to talking about the technical issues.

> When all of the pieces are public how can having secret veiled reasons
> make sense?

Legal reasoning and strategy often needs to be kept confidential.  It
may not make a lot of sense, but in the real world, lawyers can do a
lot of harm (and good) and in their area of expertise, I tend to defer
to their judgement, just as I defer to an airplane pilot on how to
safely fly me from Boston to Amsterdam.

I will observe (again) that Digital Camera manufacturers, and the
folks who came up with the DCIM standard, have for the last 10+ years
explicitly used a scheme where their cameras do not need to create
anything other than 8.3 filenames.  So at least for those folks, the
FAT Long Filename support is bloat which they don't need or want.
Furthermore, their decision to avoid anything other tghan 8.3
filenames goes back far before any patent lawsuits or settlements that
people have alleged as being related to the "why" of the patch.  Every
single digital camera does not need long file names; they all use 8.3
filenames *only* in accordance with the DCIM standard.  Is bloat
avoidance for digital cameras manufacturers who want to use Linux a
good enough reason for you?

Note: We don't always ask people for the reason behind why they want,
say, cgroups to control I/O throttling for example.  They may have a
secret business case for how they will be able to leverage that
technology with some application stack to make tons and tons of money
--- and we don't require that deep motives be revealed in those cases.
If the "what" and "how" of the patch makes sense, there is at least
one valid use case for the "why", that's often enough.  And we ought
to consider whether or not the needs of digital camera manfactuers who
might have firmware bloat requirements and who have decided over a
decade ago that 8.3 filenames were just fine for writing images to
flash cards, is a good enough reason.  Think of it as a bloatwatch
exercise, if that makes you happy.  :-)

> And if secret magic consultations with lawyers are going to be invoked
> I expect we should have a Signed-off-by from those lawyers.

That certainly wouldn't make any sense.  The lawyers didn't originate
the patch, and the code didn't pass through their hands.  Maybe a
reviewed-by or an acked-by, though.  :-)

On Mon, May 04, 2009 at 02:53:41PM -0600, Chris Friesen wrote:
>
>> Or that patent is believed to be invalid and faught, and there was
>> absolute no reason to remove it except for companies doing as part of a
>> settlement and they could do it in their privat trees.
>
> What about the scenario where a patent is valid in certain parts of the  
> world but not in others?  It seems possible that in this scenario there  
> may be valid reasons to have a config option.

Quite possibly.  

Or possibly it's because it is believed that it could be invalidated,
which is why OIN is requesting prior art even though the last time to
invalidate the patent through prior art was denied by the patent
office.  (And note, if a patent is challenged, and survives the
challenge, it gets stronger by receiving more deference from the
courts; and if it survives a second change, it gets even stronger, and
can for all practical purposes, become unchallengeable --- which is
why you don't challenge patents lightly; so I would imagine the OIN
will tread very, **very** carefully before submitting a second
challenge to the USPTO --- which is probably why the OIN *has* made a
public appeal for as much prior art as people can find; even if they
do have some good stuff, you want as much ammunition as you can,
potentially since the USPTO has refused to admit they were wrong the
first time around.)

And in the meantime, perhaps there is a desire not to fuel any FUD as
well as not wanting removing very useful functionality that desktop
users might care about over bogus patent(s), but at the same time make
it easier for companies who might not have the multiple millions of
dollars that it takes to defend against a patent lawsuit, whether or
not the patent is bullsh*t or not.

					- Ted

P.S.  Ob.Disclaimer: The above is my opinion only, and and doesn't
necessarily represent IBM or the Linux Foundation's positions,
strategies, or opinions.  I have not privately discussed this issue
with any IBM employee, contractor, or lawyer (i.e., not besides
reading the public e-mails on LKML and reading the public Ars Technica
articles on the subject).  Most of what I know about patents from an
semester-long class taught at the MIT Sloan School of Business which
covered, quite extensively, Intellectual Property Law.  Unfortunately,
it's a very good thing for a programmer to be understand; perhaps that
says something about the society we live in.
