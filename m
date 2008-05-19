Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYESA65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYESA65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYESA6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:58:49 -0400
Received: from ns1.codewiz.org ([89.97.188.34]:54224 "EHLO trinity.develer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYESA6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:58:47 -0400
Message-ID: <4830D0C4.50300@codewiz.org>
Date: Mon, 19 May 2008 02:58:44 +0200
From: Bernie Innocenti <bernie@codewiz.org>
Organization: Codewiz - http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, bernie@codewiz.org,
       lkml <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net, Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
References: <48304CE2.1090808@codewiz.org> <48304D92.1080306@develer.com> <20080518210435.GA8335@mit.edu>
In-Reply-To: <20080518210435.GA8335@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:

> P.S.  Past a certain point, you really don't want to have that many
> files in a Maildir directory; if the user is never going to be
> deleting his SPAM, then you should seriously think about using a Unix
> mbox style storage scheme.  Even with a 1k block filesystem, at 12
> million files you'll be wasting 6 gigabytes of disk space of slack
> space that is totally being wasted since the whole point of using
> Maildir is to make it easy to delete or replace individual mail
> messages.

Yes.  I'm proposing my users a cron job that will prune everything
but the most recent 2000 messages in their spamtraps.

This particular user likes to do "spam forensics" with sophisticated
Perl scripts and shell one liners, and publish pretty cool results
like this one:

simone@haring:~/Maildir$ grep -rhIos "Be [^.]*\." .Junk .junk/ | sort | uniq
Be a bunch of bastards.
Be a fool for five minutes.
Be a good person than a famous person.
Be an attraction by showing off our white gold with diamond brim.
Be attention grabbing with this watch.
Be attractive with genuine replica timepiece.
Be a very positive thing.
Be a vogue magician.
Be aware of an inherent conflict of interest resulting from such compensation.
Be aware of an inherent conflict of interest resulting from such compensation due to the fact that this is a paid advertisement and is not without bias.
Be aware of an inherent conflict of interest resulting from such holdings due to our intent to profit from the liquidation of these shares.
Be bold.
Be chic with our reasonably priced watch.
Be civil to all; sociable to many; familiar with few.
Be confidence with set of diamonds on pure gold masterpiece.
Be fashionable with our low priced watch.
Be free to choose, and not to be chosen for, is an inalienable.
Be gentle with yourself, learn to lvoe yourself, to forgive.
Be having it.
Be lying.
Be made dependent on myth nor tied to any authority lest doubt about.
Be silent, and be thought a fool, than to speak and remove all doubt.
Be Used for Any Commercial Purposes of Any Kind.


What bastard operator would deny an innocent user such an
irresistible pleasure for a few GBs of disk? :-)


> If you want to archive all of your SPAM, why use a Maildir format
> mbox at all?

You're right, but we'd have to teach all the tools that mess into
the Maildir about both formats.  I find it incredibly easier
to process email if it's in one simple format.  As in my cleanup
script:

  for i in /mail/*/.Junk.Both/cur /mail/*/.Junk.Both/new; do
      ls -t $i | tail -n +2000 | xargs rm;
  done

Easy as pie ;-)

For a while, we considered reiser3 for mail storage, but seeing
it's being marginally maintained and phased out by all distributors,
we've opted for wasting some cheap disk space instead.

-- 
   \___/
  _| X |  Bernie Innocenti - http://www.codewiz.org/
  \|_O_|  "It's an education project, not a laptop project!"
