Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbXETGzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbXETGzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXETGzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:55:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbXETGzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I9qf6yGE2vPGJivMSm+6zAccYB8PSIPsR7xXU6QGvMbpGTBSAYfrAXRWAO5XlYRZSRYaNTXVc19ZKx2GOgTljJdKTHxeJK9xuB5+q70ufrJaZRcQeG9nBNV7xsBGxYgAGsZSZZ29CD1DocmcHaI/Vcxn451z3LuABnE771ejCW8=
Message-ID: <2c0942db0705192355r2e53ccd7s6ff5cdca7b32812b@mail.gmail.com>
Date: Sat, 19 May 2007 23:55:37 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <464F99EC.3080006@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com>
	 <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com>
	 <464F99EC.3080006@tmr.com>
X-Google-Sender-Auth: eb527fa2dcc91243
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Ray Lee wrote:
> > Is the S.D. columns (immediately after the average) standard
> > deviation? If so, you may want to rename those 'stdev', as it's a
> > little confusing to have S.D. stand for that and Staircase Deadline.
> > Further, which standard deviation is it? (The standard deviation of
> > the values (stdev), or the standard deviation of the mean (sdom)?)
> >
> What's intended is the stddev from the average, and perl bit me on that
> one. If you spell a variable wrong the same way more than once it
> doesn't flag it as a possible spelling error.
>
> Note on the math, even when coded as intended, the divide of the squares
> of the errors is by N-1 not N. I found it both ways in online doc, but I
> learned it decades ago as "N-1" so I used that.

<nod> sqrt(N-1) is almost always the correct form, and gives the
"sample standard deviation". sqrt(N) (or the "population standard
deviation") should only be used when you can prove that you're not
doing any sub-sampling of the population at all, which is pretty much
never the case.

In practice, for any decent values of N, the difference between the
two is usually insignificant compared to everything else going on.

> Okay, here's a bonus, http://www.tmr.com/~davidsen/sched_smooth_02.html
> not only has the right values, the labels are changed, and I included
> more data points from the fc6 recent kernel and the 2.6.21.1 kernel with
> the mainline scheduler.

You rock.

> The nice thing about this test and the IPC test I posted recently is
> that they are reasonable stable on the same hardware, so even if someone
> argues about what they show, they show the same thing each time and can
> therefore be used to compare changes.

Yup, these look good to me.

> As I told a manger at the old Prodigy after coding up some log analysis
> with pretty graphs, "getting the data was the easy part, the hard part
> is figuring out what it means." If this data is useful in suggesting
> changes, then it has value. Otherwise it was a fun way to spend some time.

Right. At minimum, the average +- standard deviations of the glxgears
case tells a pretty consistent story, especially if one looks at the
deviation as a percentage of the average. (Mainline is far more
erratic than either SD or CFS, and CFS seems to be able to maintain
high throughput and low jitter.)

I'm not quite sure what to read into the fairness test, other than
mainline is obviously different for the other two in terms of
throughput. Deviations are across the board, but perhaps that's more a
reflection of how much (little) data was collected for this one?
Dunno.

Anyway, as you point out, the usefulness of the tests chosen could
still be up for debate, but I think you've shown that the results are
pretty stable, and at least can serve as a good measure between
versions of schedulers.
