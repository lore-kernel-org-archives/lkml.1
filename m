Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZJNR5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZJNR5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZJNR5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZJNR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:57:04 -0400
Date: Wed, 14 Oct 2009 13:55:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, Jens Axboe <jens.axboe@oracle.com>,
       Nauman Rafique <nauman@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Dong-Jae Kang <baramsori72@gmail.com>,
       Isaku Yamahata <yamahata@valinux.co.jp>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Akio Takebe <takebe_akio@jp.fujitsu.com>
Subject: Re: IO controller Mini-Summit 2009
Message-ID: <20091014175521.GG3528@redhat.com>
References: <20091014.212444.179938286.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014.212444.179938286.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 09:24:44PM +0900, Ryo Tsuruta wrote:
> Hello,
> 

Hi Ryo,

CCing people who are planning to attend the mini summit either in person
or phone. (As per your list on io mini summit wiki page). Not sure if
everybody is scanning mailing list for update on mini summit.

I am checking out wiki page for more information like Venue. It says the
venue is linux foundation office Japan. Hopefully there is no change in
that information.

What are the conference call details for the people who might want to join
in over phone? Could not find those. Are you yet to post these?

Thanks
Vivek

> I have summarized the topics for the IO controller mini-summit and
> written the ideas seen in the mailing list.
> 
> - The place where IO controller should be implemented
>   - Block layer in conjunction with the IO scheduler
>   - Common layer right above the IO scheduler
>   - CFQ enhancement.
>   - Both block and common layer, users can select whichever controller
>     they want.
>   - VFS layer
> 
> - What kind of bandwidth control policies are needed?
>   - Proportional weight
>   - Enforcing upper limit
>   - Minimum bandwidth guarantee
> 
> - How to handle buffered writes?
>   - Add dirt-ratio in the memory controller
>   - Add bufferred-write-cgroup to track buffered writebacks
>   - A per group per bdi pdflush threads
> 
> - Who should be charged for swap activity?
>   - who requests a page.
>   - who has a page.
>   - All swap activities are charged to the root group.
> 
> And I would also like to discuss about the followings.
> 
> - Extensions of struct bio
>   - Make a bio point to the io_context of a process which creates the
>     I/O request. This allows to pass the IO scheduling class and
>     priority information to IO controller even if the IO is submitted
>     by another process which does not create the request, such as a
>     worker thread.
>   - Add a new flag to struct bio to identify the bio as urgent. This
>     gives IO controller a chance to handle the bio as high
>     priority. This flag should be set if the bio is created for the
>     page-out operation. 
> 
> - Common test methods to verify the functionality of IO controller.
> 
> Please give me comments and suggestions. I may be missing or
> misunderstanding something.
> 
> Thanks,
> Ryo Tsuruta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
