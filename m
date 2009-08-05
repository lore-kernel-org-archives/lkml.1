Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbZHEKTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbZHEKTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZHEKTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:19:13 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:36489 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbZHEKTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:19:11 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2009 06:19:11 EDT
Message-ID: <4A795B07.4070708@sophos.com>
Date: Wed, 05 Aug 2009 11:12:23 +0100
From: Douglas Leeder <douglas.leeder@sophos.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
CC: Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>, "pavel@suse.cz" <pavel@suse.cz>
Subject: Re: fanotify - overall design before I start sending patches
References: <1248466429.3567.82.camel@localhost> <200908041734.05762.tvrtko.ursulin@sophos.com>
In-Reply-To: <200908041734.05762.tvrtko.ursulin@sophos.com>
X-Enigmail-Version: 0.96.0
OpenPGP: id=B1498EA3
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 11:12:23,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 11:12:24,
	Serialize complete at 05/08/2009 11:12:24
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> On Friday 24 July 2009 21:13:49 Eric Paris wrote:
>> After the socket is bound events are attained using the read() syscall
>> (recv* probably also works haven't tested).  This will result in the
>> buffer being filled with one or more events like this:
>>
>> struct fanotify_event_metadata {
>>         __u32 event_len;
>>         __s32 fd;
>>         __u32 mask;
>>         __u32 f_flags;
>>         __s32 pid;
>>         __s32 tgid;
>>         __u64 cookie;
>> }  __attribute__((packed));
>>
>> fd specifies the new file descriptor that was created in the context of
>> the listener.  (readlink of /proc/self/fd will give you A pathname)
>> mask indicates the events type (bitwise OR of the event types listed
>> above).  f_flags here is the f_flags the ORIGINAL process has the file
>> open with.  pid and tgid are from the original process.  cookie is used
>> when the listener needs to allow, deny, or delay the operation.
> 
> One more thing. uid and gid (possibly whole set?) would be useful so we can 
> tell which user triggered an event without having to look at the process 
> which has maybe disappeared in the mean time. I _think_ uid was in the 
> original proposal/idea and don't remember if it was decided we cannot get it 
> deliberately, or it was omitted by accident?

Maybe it would be good to include in the documentation how to extract
extra information that listeners might want?

e.g.

To get the path (or an approximation), do readlink on the fd.

To get the UID/GID of the originator process, look in /proc/<PID>/????

etc.

This would provide easier answers to the questions on including extra
info in the fanotify events.

-- 
Douglas Leeder
