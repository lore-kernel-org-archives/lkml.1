Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbZHDJem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbZHDJem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932716AbZHDJel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:34:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39409 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbZHDJel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:34:41 -0400
Date: Tue, 4 Aug 2009 12:33:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: davidel@xmailserver.org, gleb@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
Message-ID: <20090804093332.GA3334@redhat.com>
References: <cover.1248803500.git.mst@redhat.com> <20090728175538.GC21549@redhat.com> <4A76FDB2.7080706@redhat.com> <20090803151426.GA3630@redhat.com> <4A770260.5000507@redhat.com> <20090803165708.GB3630@redhat.com> <4A77F6EF.8010002@redhat.com> <20090804085406.GA3311@redhat.com> <4A77FCB8.1000205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A77FCB8.1000205@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 12:17:44PM +0300, Avi Kivity wrote:
> On 08/04/2009 11:54 AM, Michael S. Tsirkin wrote:
>> On Tue, Aug 04, 2009 at 11:53:03AM +0300, Avi Kivity wrote:
>>    
>>> On 08/03/2009 07:57 PM, Michael S. Tsirkin wrote:
>>>      
>>>>> Why not do it at the point of the write?
>>>>>
>>>>>       if (value != ctx->count) {
>>>>>           ctx->count = value;
>>>>>           wake_things_up();
>>>>>       }
>>>>>
>>>>>          
>>>> What if write comes before read?
>>>>
>>>>        
>>> The read will get the new value.
>>>      
>>
>> Yes :) But how does read know it should not block?
>>    
>
> If a different read comes after the write but after our read, it will  
> have transferred the value, resulting in the same situation.

Not the same: one reader wakes up, others sleep.

Multiple reads from the same fd behave this way for any file I can think
of. Consider regular eventfd, or a pipe, a socket ...  But if we want to
support blocking reads, we probably should not require the readers to
sync with writers.


> I think reads should never block with a state based mechanism.

Yes, with no support for blocking reads, we don't need the state.
In that case, we probably want to error on open out unless O_NONBLOCK is
specified.  But why is this a good idea?


> -- 
> error compiling committee.c: too many arguments to function
