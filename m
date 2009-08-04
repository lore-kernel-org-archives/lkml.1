Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbZHDQeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbZHDQeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932882AbZHDQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:34:09 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:33545 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbZHDQeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:34:08 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify - overall design before I start sending patches
Date: Tue, 4 Aug 2009 17:34:04 +0100
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
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
References: <1248466429.3567.82.camel@localhost>
In-Reply-To: <1248466429.3567.82.camel@localhost>
MIME-Version: 1.0
Message-Id: <200908041734.05762.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:34:06,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:34:06,
	Serialize complete at 04/08/2009 17:34:06
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009 21:13:49 Eric Paris wrote:
> After the socket is bound events are attained using the read() syscall
> (recv* probably also works haven't tested).  This will result in the
> buffer being filled with one or more events like this:
>
> struct fanotify_event_metadata {
>         __u32 event_len;
>         __s32 fd;
>         __u32 mask;
>         __u32 f_flags;
>         __s32 pid;
>         __s32 tgid;
>         __u64 cookie;
> }  __attribute__((packed));
>
> fd specifies the new file descriptor that was created in the context of
> the listener.  (readlink of /proc/self/fd will give you A pathname)
> mask indicates the events type (bitwise OR of the event types listed
> above).  f_flags here is the f_flags the ORIGINAL process has the file
> open with.  pid and tgid are from the original process.  cookie is used
> when the listener needs to allow, deny, or delay the operation.

One more thing. uid and gid (possibly whole set?) would be useful so we can 
tell which user triggered an event without having to look at the process 
which has maybe disappeared in the mean time. I _think_ uid was in the 
original proposal/idea and don't remember if it was decided we cannot get it 
deliberately, or it was omitted by accident?

Tvrtko
